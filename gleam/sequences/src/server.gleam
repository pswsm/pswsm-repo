import gleam/bytes_builder
import gleam/erlang/process
import gleam/http
import gleam/http/request
import gleam/http/response
import gleam/io
import gleam/option.{Some}
import gleam/otp/actor
import mist

pub fn main() {
  let selector = process.new_selector()
  let state = Nil

  let not_found =
    response.new(404)
    |> response.set_body(mist.Bytes(bytes_builder.new()))

  let assert Ok(_) =
    fn(req: request.Request(mist.Connection)) -> response.Response(
      mist.ResponseData,
    ) {
      io.debug("Request received")
      io.debug("Path segments:")
      io.debug(request.path_segments(req))
      case request.path_segments(req) {
        ["ws"] ->
          mist.websocket(
            request: req,
            on_init: fn(_conn) { #(state, Some(selector)) },
            on_close: fn(_state) { io.println("goodbye!") },
            handler: handle_ws_message,
          )
        ["api", ..] -> api_handler(req)
        _ -> not_found
      }
    }
    |> mist.new
    |> mist.port(3000)
    |> mist.start_http

  process.sleep_forever()
}

pub fn api_handler(req: request.Request(mist.Connection)) {
  let response =
    response.new(200)
    |> response.set_body(mist.Bytes(bytes_builder.new()))

  case req.method {
    http.Get -> response
    _ ->
      response.new(405)
      |> response.set_body(mist.Bytes(bytes_builder.new()))
  }
}

pub fn handle_ws_message(state, connection, message) {
  io.debug("Received message:")
  io.debug(message)
  case message {
    mist.Text("ping") -> {
      let assert Ok(_) = mist.send_text_frame(connection, "pong")
      actor.continue(state)
    }
    mist.Text(_) | mist.Binary(_) -> {
      actor.continue(state)
    }
    mist.Custom(_) -> actor.continue(state)
    mist.Closed | mist.Shutdown -> actor.Stop(process.Normal)
  }
}
