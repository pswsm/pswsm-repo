import gleam/bytes_builder
import gleam/http/response
import gleam/int
import gleam/json
import mist

pub opaque type HttpError {
  RequestError(code: Int, message: String)
  ServerError(code: Int, message: String)
}

pub fn new_bad_request() -> HttpError {
  RequestError(400, "Bad request")
}

pub fn new_not_found() -> HttpError {
  RequestError(404, "Not found")
}

pub fn new_internal_server_error() -> HttpError {
  ServerError(500, "Internal server error")
}

pub fn set_message(
  error: HttpError,
  custom_message message: String,
) -> HttpError {
  case error {
    RequestError(code, _) -> RequestError(code, message)
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
    RequestError(_, message) -> message
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
