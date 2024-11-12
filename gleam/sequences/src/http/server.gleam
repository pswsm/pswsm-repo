import gleam/erlang/process
import gleam/http
import gleam/http/request
import gleam/http/response
import gleam/option
import gleam/string
import http/api/get
import http/api/post
import http/http_errors
import kernel/logger
import mist
import utils

pub fn run(port: Int) {
  let _selector = process.new_selector()
  let _state = Nil

  let assert Ok(_) =
    fn(req: request.Request(mist.Connection)) -> response.Response(
      mist.ResponseData,
    ) {
      handle(req.method, request.path_segments(req), req)
    }
    |> mist.new
    |> mist.port(port)
    |> mist.start_http

  process.sleep_forever()
}

fn handle(
  method m: http.Method,
  path p: List(String),
  request r: request.Request(mist.Connection),
) -> response.Response(mist.ResponseData) {
  logger.info(
    http.method_to_string(m) |> string.uppercase
    <> " "
    <> p |> utils.implode(option.Some("/")),
  )
  case m, p {
    http.Get, ["api", ..] -> get.handle_get_api(p, r)
    http.Post, ["api", ..] -> post.handle_post_api(p, r)
    _, _ -> http_errors.new_not_found() |> http_errors.to_response
  }
}
