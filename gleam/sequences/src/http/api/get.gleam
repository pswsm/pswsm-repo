import gleam/bit_array
import gleam/bytes_builder
import gleam/http/request
import gleam/http/response
import gleam/json
import gleam/list
import gleam/option
import gleam/result
import http/errors
import infrastructure/sql
import mist
import users/users
import utils

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

  let req =
    req
    |> request.path_segments
    |> utils.remove_first
    |> utils.implode(option.Some("/"))
    |> fn(path) { request.set_path(req, path) }

  case request.path_segments(req) {
    ["users"] -> handle_get_user(response)
    _ -> response
  }
}

fn handle_get_user(base_response: response.Response(mist.ResponseData)) {
  let users = users.find_all(sql.localdb)

  case users {
    Ok(users) -> {
      base_response
      |> response.set_body(mist.Bytes(
        bytes_builder.new()
        |> bytes_builder.append_string(
          users
          |> list.map(fn(t) {
            json.object([
              #(
                "id",
                json.string(t.0 |> bit_array.to_string |> result.unwrap("-1")),
              ),
              #("username", json.string(t.1)),
            ])
          })
          |> json.preprocessed_array()
          |> fn(users) { json.object([#("users", users)]) }
          |> json.to_string,
        ),
      ))
    }
    Error(_) -> errors.new_not_found() |> errors.to_response
  }
}
