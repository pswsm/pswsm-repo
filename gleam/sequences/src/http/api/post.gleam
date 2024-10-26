import gleam/http/request
import gleam/option
import gleam/result
import http/api/post_utils
import http/http_errors
import http/http_utils
import http/responses
import mist
import users/user_errors
import users/users
import utils

pub fn handle_post_api(
  path path: List(String),
  request req: request.Request(mist.Connection),
) {
  use <- option.lazy_unwrap(http_utils.authorize(req))

  let path = utils.remove_first(path)

  case path {
    ["users"] -> handle_post_user(req)
    _ -> http_errors.new_bad_request() |> http_errors.to_response
  }
}

fn handle_post_user(req: request.Request(mist.Connection)) {
  use body <- utils.if_error(mist.read_body(req, 1024 * 1024 * 10), fn(_) {
    http_errors.new_bad_request() |> http_errors.to_response
  })
  use decoded_body <- utils.if_error(post_utils.decode_body(body), fn(_) {
    http_errors.new_bad_request() |> http_errors.to_response
  })
  use validated_body <- utils.if_error(
    post_utils.validate_body_fields(Ok(decoded_body), [
      "id", "password", "username",
    ]),
    fn(error) { error |> http_errors.to_response },
  )
  use username <- utils.if_error(
    utils.get_key(validated_body, "username"),
    fn(_) { http_errors.new_bad_request() |> http_errors.to_response },
  )
  use password <- utils.if_error(
    utils.get_key(validated_body, "password"),
    fn(_) { http_errors.new_bad_request() |> http_errors.to_response },
  )
  use id <- utils.if_error(utils.get_key(validated_body, "id"), fn(_) {
    http_errors.new_bad_request() |> http_errors.to_response
  })

  let user = users.new(id, username, password)
  use _created_user <- utils.if_error(users.save(user), fn(error_message) {
    http_errors.new_internal_server_error()
    |> http_errors.set_message(user_errors.message(error_message))
    |> http_errors.to_response
  })

  responses.created() |> responses.to_mist
}
