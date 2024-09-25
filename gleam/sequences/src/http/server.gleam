import gleam/bytes_builder
import gleam/erlang/process
import gleam/http
import gleam/http/request
import gleam/http/response
import http/api/get
import http/api/post
import http/errors
import mist

pub fn run() {
  let _selector = process.new_selector()
  let _state = Nil

  // TODO: Read from config
  let port = 3000

  let json_response =
    response.new(200)
    |> response.set_header("Content-Type", "application/json")
    |> response.set_body(mist.Bytes(bytes_builder.new()))

  let not_found = errors.new_not_found()

  let assert Ok(_) =
    fn(req: request.Request(mist.Connection)) -> response.Response(
      mist.ResponseData,
    ) {
      case req.method, request.path_segments(req) {
        http.Get, ["api", ..] -> get.handle_get_api(req, json_response)
        http.Post, ["api", ..] -> post.handle_post_api(req, json_response)
        _, _ -> not_found |> errors.to_response
      }
    }
    |> mist.new
    |> mist.port(port)
    |> mist.start_http

  process.sleep_forever()
}
