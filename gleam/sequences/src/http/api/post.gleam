import gleam/bytes_builder
import gleam/dict
import gleam/dynamic
import gleam/http/request
import gleam/http/response
import gleam/int
import gleam/io
import gleam/json
import gleam/option
import gleam/result
import http/errors
import infrastructure/sql
import mist
import users/users
import utils

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

fn handle_post_user(
  req: request.Request(mist.Connection),
  res: response.Response(mist.ResponseData),
) {
  mist.read_body(req, 1024 * 1024 * 10)
  |> result.map_error(fn(_) { errors.new_bad_request() })
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
    |> result.map_error(fn(_) {
      errors.new_bad_request() |> errors.set_message("Invalid JSON")
    })
  })
  |> result.try(fn(user_dict) {
    dict.get(user_dict, "id")
    |> result.is_error
    |> fn(is_error) {
      case is_error {
        True ->
          Error(
            errors.new_bad_request() |> errors.set_message("Missing field 'id'"),
          )
        False -> Ok(user_dict)
      }
    }
  })
  |> result.try(fn(user_dict) {
    dict.get(user_dict, "username")
    |> result.is_error
    |> fn(is_error) {
      case is_error {
        True ->
          Error(
            errors.new_bad_request()
            |> errors.set_message("Missing field 'user'"),
          )
        False -> Ok(user_dict)
      }
    }
  })
  |> result.map(fn(user) {
    let user =
      users.new(
        id: dict.get(user, "id") |> result.unwrap("-1"),
        password: dict.get(user, "password") |> result.unwrap("default"),
        username: dict.get(user, "username") |> result.unwrap("default"),
      )

    user |> users.save(option.Some(sql.localdb))
  })
  // TODO: handle errors
  |> io.debug
  |> result.map_error(fn(_) { errors.new_internal_server_error() })
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
  |> result.map_error(fn(error) { error |> errors.to_response })
  |> result.unwrap_both
}
