import auth/auth
import gleam/bool
import gleam/http/request
import gleam/http/response
import gleam/option
import gleam/result
import http/http_errors
import mist

pub fn authorize(
  request r: request.Request(mist.Connection),
) -> option.Option(response.Response(mist.ResponseData)) {
  use <- bool.guard(
    request.get_header(r, "authorization") |> result.is_error,
    http_errors.new_bad_request() |> http_errors.to_response |> option.Some,
  )
  use <- bool.guard(
    request.get_header(r, "authorization")
      |> result.unwrap("")
      |> auth.can_access
      |> bool.negate,
    http_errors.new_unauthorized() |> http_errors.to_response |> option.Some,
  )
  option.None
}
