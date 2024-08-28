import gleam/bytes_builder
import gleam/dynamic
import gleam/erlang/process
import gleam/http
import gleam/http/request
import gleam/http/response
import gleam/io
import gleam/json
import gleam/list
import gleam/option
import infra
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
      |> bytes_builder.append_string(
        json.object([#("message", json.string("Hello, World!"))])
        |> json.to_string,
      ),
    ))

  let path_segments = request.path_segments(req)

  let req =
    req
    |> request.set_path(
      utils.remove_first(path_segments) |> utils.implode(option.Some("/")),
    )
  case request.path_segments(req) {
    ["users"] -> handle_get_user(response)
    _ -> response
  }
}

fn handle_get_user(base_response: response.Response(mist.ResponseData)) {
  io.debug("Handling get user")
  let users =
    infra.ask(
      infra.localdb,
      "select * from users",
      [],
      dynamic.tuple2(dynamic.int, dynamic.string),
    )

  base_response
  |> response.set_body(mist.Bytes(
    bytes_builder.new()
    |> bytes_builder.append_string(
      users
      |> list.map(fn(t) {
        json.object([#("id", json.int(t.0)), #("name", json.string(t.1))])
      })
      |> json.preprocessed_array()
      |> json.to_string,
    ),
  ))
}
