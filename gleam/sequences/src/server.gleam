import gleam/bytes_builder
import gleam/erlang/process
import gleam/http
import gleam/http/request
import gleam/http/response
import gleam/json
import gleam/option
import mist
import utils

pub fn run() {
  let _selector = process.new_selector()
  let _state = Nil

  // TODO: Read from config
  let port = 3000

  let json_response =
    response.new(200)
    |> response.set_header("Content-Type", "application/json")
    |> response.set_body(mist.Bytes(bytes_builder.new()))

  let not_found =
    response.new(404)
    |> response.set_body(mist.Bytes(
      bytes_builder.new() |> bytes_builder.append_string("Not found"),
    ))

  let _not_supported =
    response.new(405)
    |> response.set_body(mist.Bytes(
      bytes_builder.new() |> bytes_builder.append_string("Method not supported"),
    ))

  let assert Ok(_) =
    fn(req: request.Request(mist.Connection)) -> response.Response(
      mist.ResponseData,
    ) {
      case req.method, request.path_segments(req) {
        http.Get, ["api", ..] -> handle_get_api(req, json_response)
        _, _ -> not_found
      }
    }
    |> mist.new
    |> mist.port(port)
    |> mist.start_http

  process.sleep_forever()
}

pub fn handle_get_api(
  req: request.Request(mist.Connection),
  base_response: response.Response(mist.ResponseData),
) {
  let response =
    base_response
    |> response.set_body(mist.Bytes(
      bytes_builder.new()
      |> bytes_builder.append(
        bytes_builder.new()
        |> bytes_builder.append_string(
          json.object([#("message", json.string("Hello, World!"))])
          |> json.to_string,
        )
        |> bytes_builder.to_bit_array,
      ),
    ))

  let path_segments = request.path_segments(req)

  // TODO: uncomment when proper api
  let _req =
    req
    |> request.set_path(
      utils.remove_first(path_segments) |> utils.implode(option.Some("/")),
    )
  // TODO: handle deeper api paths :)
  response
}
