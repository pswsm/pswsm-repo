import auth/auth
import gleam/http/request
import gleam/http/response
import gleam/io
import gleam/json
import gleam/option
import gleam/string
import http/api/post_utils
import http/http_errors
import http/http_utils
import http/responses
import kernel/logger
import mist
import users/create
import users/id
import users/password
import users/user_errors
import users/user_finder
import users/username
import users/users
import utils

pub fn handle_post_api(
  path path: List(String),
  request req: request.Request(mist.Connection),
) {
  let path = utils.remove_first(path)

  case path {
    ["users", ..] -> handle_post_user(req)
    ["tokens", ..] -> handle_post_tokens(req)
    _ -> http_utils.method_not_allowed(req)
  }
}

fn handle_post_user(req: request.Request(mist.Connection)) {
  use <- option.lazy_unwrap(http_utils.authorize(req))

  use body <- utils.if_error(mist.read_body(req, 1024 * 1024 * 10), fn(_) {
    http_errors.bad_request(option.Some("invalid body"))
    |> http_errors.to_response
  })
  use decoded_body <- utils.if_error(
    post_utils.decode_body(body),
    http_errors.to_response,
  )
  use id <- utils.if_error(
    utils.get_key(decoded_body, "id", id.from_string),
    post_utils.get_key_error,
  )
  use username <- utils.if_error(
    utils.get_key(decoded_body, "username", username.new),
    post_utils.get_key_error,
  )
  use password <- utils.if_error(
    utils.get_key(decoded_body, "password", password.new),
    post_utils.get_key_error,
  )

  let assert Ok(password) = password

  let user = users.new(id, username, password)

  // TODO: user_creator creates User record and persists,
  // User record should not be created here in the route handler
  use _ <- utils.if_error(create.create(user), fn(error) {
    http_errors.new_internal_server_error()
    |> http_errors.set_message(user_errors.message(error))
    |> http_errors.to_response
  })

  responses.created() |> responses.to_mist
}

fn handle_post_tokens(with request: request.Request(mist.Connection)) {
  use body <- utils.if_error(mist.read_body(request, 1024 * 1024 * 10), fn(_) {
    http_errors.bad_request(option.Some("invalid body"))
    |> http_errors.to_response
  })
  use decoded_body <- utils.if_error(
    post_utils.decode_body(body),
    http_errors.to_response,
  )
  io.debug(decoded_body)
  use username <- utils.if_error(
    utils.get_key(decoded_body, "username", username.new),
    post_utils.get_key_error,
  )
  use password <- utils.if_error(
    utils.get_key(decoded_body, "password", fn(p) {
      password.from(p, string.trim(_))
    }),
    post_utils.get_key_error,
  )

  logger.debug(username |> username.value_of)
  logger.debug(password |> password.value_of)

  use user <- utils.if_error(user_finder.get_by_username(username), fn(_) {
    http_errors.not_found(option.Some("user not found"))
    |> http_errors.to_response
  })

  use auth <- utils.if_error(auth.auth(user, password), fn(message) {
    http_errors.forbidden(message |> auth.get_message |> option.Some)
    |> http_errors.to_response
  })

  responses.ok()
  |> response.set_body(
    [#("accessToken", auth |> json.string)] |> json.object |> json.to_string,
  )
  |> responses.to_mist
}
