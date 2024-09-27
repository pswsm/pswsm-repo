import gleam/dict
import gleam/http/request
import gleam/json
import gleam/result
import http/api/post_utils
import http/http_errors
import http/responses
import mist
import users/user_errors
import users/users
import utils

pub fn handle_post_api(
  path path: List(String),
  request req: request.Request(mist.Connection),
) {
  let path = utils.remove_first(path)

  case path {
    ["users"] -> handle_post_user(req)
    _ -> http_errors.new_bad_request() |> http_errors.to_response
  }
}

fn handle_post_user(req: request.Request(mist.Connection)) {
  mist.read_body(req, 1024 * 1024 * 10)
  |> result.map_error(fn(_) { http_errors.new_bad_request() })
  |> result.try(post_utils.decode_body)
  |> post_utils.validate_fields(["id", "password", "username"])
  |> result.map(fn(user) {
    users.new(
      id: dict.get(user, "id") |> result.unwrap("default"),
      password: dict.get(user, "password") |> result.unwrap("default"),
      username: dict.get(user, "username") |> result.unwrap("default"),
    )
  })
  |> result.try(fn(user) {
    users.save(user)
    |> result.map_error(fn(error) {
      http_errors.new_internal_server_error()
      |> http_errors.set_message(error |> user_errors.message)
    })
  })
  |> result.map(fn(_) {
    responses.base_response()
    |> responses.with_json_body(
      json.object([#("message", json.string("User created"))]),
    )
    |> responses.to_mist
  })
  |> result.map_error(fn(error) { error |> http_errors.to_response })
  |> result.unwrap_both
}
