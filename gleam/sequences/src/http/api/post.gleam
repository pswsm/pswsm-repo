import gleam/http/request
import gleam/option
import http/api/post_utils
import http/http_errors
import http/http_utils
import http/responses
import mist
import users/user_errors
import users/user_saver
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
    http_errors.bad_request("invalid body") |> http_errors.to_response
  })
  use decoded_body <- utils.if_error(post_utils.decode_body(body), fn(error) {
    error |> http_errors.to_response
  })
  use username <- utils.if_error(
    utils.get_key(decoded_body, "id"),
    post_utils.get_key_error,
  )
  use password <- utils.if_error(
    utils.get_key(decoded_body, "password"),
    post_utils.get_key_error,
  )

  let user = users.new(username, password)

  use _saved_user <- utils.if_error(user_saver.save(user), fn(error) {
    http_errors.new_internal_server_error()
    |> http_errors.set_message(user_errors.message(error))
    |> http_errors.to_response
  })

  responses.created() |> responses.to_mist
}
