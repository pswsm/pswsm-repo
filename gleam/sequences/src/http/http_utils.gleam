import auth/auth
import auth/token
import gleam/bool
import gleam/http
import gleam/http/request
import gleam/http/response
import gleam/option
import gleam/string
import http/http_errors
import mist
import utils

/// Checks if a request is authorized to go through.
/// If the request is not authorized, it returns a response with the appropriate status code.
/// If the request is authorized, it returns None.
///
/// # Arguments
/// * `r` - The request to authorize.
/// # Returns
/// * A response with the appropriate status code if the request is not authorized.
/// * None if the request is authorized.
pub fn authorize(
  request r: request.Request(mist.Connection),
) -> option.Option(response.Response(mist.ResponseData)) {
  use header <- utils.if_error(request.get_header(r, "authorization"), fn(_) {
    http_errors.bad_request(option.None)
    |> http_errors.to_response
    |> option.Some
  })
  use #(_, header_token) <- utils.if_error(
    header |> string.split_once(" "),
    fn(_) {
      http_errors.bad_request(option.Some("invalid authorization header"))
      |> http_errors.to_response
      |> option.Some
    },
  )
  use token <- utils.if_error(token.from_jwt(header_token), fn(message) {
    http_errors.unauthorized(option.Some(message))
    |> http_errors.to_response
    |> option.Some
  })
  use <- bool.guard(
    auth.can_access(token) |> bool.negate,
    http_errors.unauthorized(option.Some("token expired"))
      |> http_errors.to_response
      |> option.Some,
  )
  option.None
}

pub fn method_not_allowed(
  req: request.Request(_),
) -> response.Response(mist.ResponseData) {
  let method = req.method |> http.method_to_string |> string.uppercase
  let path = req.path
  http_errors.bad_request(option.Some("cannot " <> method <> " " <> path))
  |> http_errors.to_response
}
