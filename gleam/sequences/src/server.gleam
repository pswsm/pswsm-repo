import gleam/bytes_builder
import gleam/dict
import gleam/dynamic
import gleam/erlang/process
import gleam/http
import gleam/http/request
import gleam/http/response
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/option
import gleam/result
import gleam/string_builder
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
        http.Post, ["api", ..] -> handle_post_api(req, json_response)
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
      option.None,
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

pub fn handle_post_api(
  req: request.Request(mist.Connection),
  base_response: response.Response(mist.ResponseData),
) {
  let path_segments = request.path_segments(req)

  let req =
    req
    |> request.set_path(
      utils.remove_first(path_segments) |> utils.implode(option.Some("/")),
    )
  case request.path_segments(req) {
    ["users"] -> handle_post_user(req, base_response)
    _ -> base_response
  }
}

pub fn handle_post_user(
  req: request.Request(mist.Connection),
  res: response.Response(mist.ResponseData),
) {
  mist.read_body(req, 1024 * 1024 * 10)
  |> result.nil_error()
  |> result.try(fn(req) {
    json.decode_bits(
      req.body,
      dynamic.dict(
        dynamic.string,
        dynamic.any(of: [
          dynamic.string,
          fn(x) { dynamic.int(x) |> result.map(fn(x) { int.to_string(x) }) },
        ]),
      ),
    )
    |> io.debug
    |> result.nil_error
  })
  |> result.map(fn(user) {
    let query =
      string_builder.new()
      // TODO: get col names from dict keys
      |> string_builder.append("insert into users (id, username) values (")
      |> string_builder.append(dict.get(user, "id") |> result.unwrap("-1"))
      |> string_builder.append(", '")
      |> string_builder.append(dict.get(user, "username") |> result.unwrap(""))
      |> string_builder.append("')")
      |> string_builder.to_string
    infra.order(who: infra.localdb, query: query)
  })
  // TODO: handle errors
  |> io.debug
  |> result.map_error(fn(_) {
    response.new(500)
    |> response.set_body(mist.Bytes(bytes_builder.new()))
  })
  |> result.map(fn(_) {
    res
    |> response.set_body(mist.Bytes(
      bytes_builder.new()
      |> bytes_builder.append_string(
        json.object([#("message", json.string("User created"))])
        |> json.to_string,
      ),
    ))
  })
  |> result.lazy_unwrap(fn() {
    res
    |> response.set_body(mist.Bytes(
      bytes_builder.new()
      |> bytes_builder.append_string(
        json.object([#("message", json.string("Invalid request"))])
        |> json.to_string,
      ),
    ))
  })
}
