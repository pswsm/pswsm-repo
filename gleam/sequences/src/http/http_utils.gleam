import auth/auth
import auth/token
import gleam/bool
import gleam/http/request
import gleam/http/response
import gleam/option
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
  use token <- utils.if_error(token.from_string(header), fn(message) {
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
