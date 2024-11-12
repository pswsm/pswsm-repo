import gleam/bytes_builder
import gleam/http/response
import gleam/int
import gleam/json
import gleam/option
import mist

pub opaque type HttpError {
  RequestError(code: Int, message: option.Option(String))
  ServerError(code: Int, message: String)
}

pub fn bad_request(message: option.Option(String)) -> HttpError {
  RequestError(400, message)
}

pub fn unauthorized(message: option.Option(String)) -> HttpError {
  RequestError(401, message)
}

@deprecated("Use `bad_request` instead")
pub fn new_bad_request() -> HttpError {
  RequestError(400, option.Some("Bad request"))
}

@deprecated("Use `unauthorized` instead")
pub fn new_unauthorized() -> HttpError {
  RequestError(401, option.Some("Unauthorized"))
}

pub fn new_not_found() -> HttpError {
  RequestError(404, option.Some("Not found"))
}

pub fn new_internal_server_error() -> HttpError {
  ServerError(500, "Internal server error")
}

pub fn set_message(
  error: HttpError,
  custom_message message: String,
) -> HttpError {
  case error {
    RequestError(code, _) -> {
      case message {
        "" -> RequestError(code, option.None)
        _ -> RequestError(code, option.Some(message))
      }
    }
    ServerError(code, _) -> ServerError(code, message)
  }
}

pub fn code(error: HttpError) -> Int {
  case error {
    RequestError(code, _) -> code
    ServerError(code, _) -> code
  }
}

pub fn message(error: HttpError) -> String {
  case error {
    RequestError(_, message) -> message |> option.unwrap("Request error")
    ServerError(_, message) -> message
  }
}

pub fn to_response(error: HttpError) -> response.Response(mist.ResponseData) {
  response.new(code(error))
  |> response.set_header("Content-Type", "application/json")
  |> response.set_body(mist.Bytes(
    bytes_builder.new()
    |> bytes_builder.append_string(
      [
        #("code", json.string(code(error) |> int.to_string)),
        #("message", json.string(message(error))),
      ]
      |> json.object
      |> json.to_string,
    ),
  ))
}
