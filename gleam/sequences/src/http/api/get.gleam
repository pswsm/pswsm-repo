import gleam/http/request
import gleam/json
import gleam/option
import http/http_errors as errors
import http/http_utils
import http/responses
import posts/apps/finder
import posts/domain/errors as post_errors
import posts/domain/post
import users/id
import users/user_errors
import users/user_finder
import users/users
import utils

pub fn handle_get_api(path: List(String), request r: request.Request(_)) {
  let path = path |> utils.remove_first
  case path {
    ["users", id] -> get_user(id, r)
    ["posts", id] -> get_post(id, r)
    _ -> errors.not_found(option.None) |> errors.to_response
  }
}

pub fn get_user(id user_id: String, request r: request.Request(_)) {
  use <- option.lazy_unwrap(http_utils.authorize(r))
  use user <- utils.if_error(
    user_finder.get_by_id(id.from_string(user_id)),
    fn(error) {
      errors.not_found(option.Some(user_errors.message(error)))
      |> errors.to_response
    },
  )

  responses.ok()
  |> responses.with_json_body(user |> users.to_primitives |> json.object)
  |> responses.to_mist
}

pub fn get_post(id post_id: String, request r: request.Request(_)) {
  use <- option.lazy_unwrap(http_utils.authorize(r))
  use post <- utils.if_error(finder.get(post_id), fn(error) {
    errors.not_found(option.Some(post_errors.log(error)))
    |> errors.to_response
  })

  responses.ok()
  |> responses.with_json_body(post |> post.to_primitives |> json.object)
  |> responses.to_mist
}
