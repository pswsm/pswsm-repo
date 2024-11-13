import gleam/http/request
import gleam/json
import gleam/option
import http/http_errors as errors
import http/http_utils
import http/responses
import users/user_errors
import users/user_finder
import users/username
import users/users
import utils

pub fn handle_get_api(path: List(String), request r: request.Request(_)) {
  let path = path |> utils.remove_first
  case path {
    ["users", id] -> get(id, r)
    _ -> errors.not_found(option.None) |> errors.to_response
  }
}

pub fn get(id username: String, request r: request.Request(_)) {
  use <- option.lazy_unwrap(http_utils.authorize(r))
  use user <- utils.if_error(
    user_finder.get_by_username(username.new(username)),
    fn(error) {
      errors.not_found(option.Some(user_errors.message(error)))
      |> errors.to_response
    },
  )

  responses.ok()
  |> responses.with_json_body(user |> users.to_primitives |> json.object)
  |> responses.to_mist
}
