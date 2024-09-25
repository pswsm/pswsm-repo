// TODO: think appropiate name for this use post utils file
import gleam/dict
import gleam/dynamic
import gleam/http/request
import gleam/int
import gleam/json
import gleam/result
import http/errors
import utils

pub fn decode_body(
  req: request.Request(_),
) -> Result(dict.Dict(String, String), errors.HttpError) {
  json.decode_bits(
    req.body,
    dynamic.dict(
      dynamic.string,
      dynamic.any(of: [
        dynamic.string,
        fn(x) { dynamic.int(x) |> result.map(fn(x) { int.to_string(x) }) },
      ]),
    ),
  )
  |> result.map_error(fn(_) {
    errors.new_bad_request() |> errors.set_message("Invalid JSON")
  })
}

pub fn validate(
  d: Result(dict.Dict(String, String), errors.HttpError),
  key: String,
) -> Result(dict.Dict(String, String), errors.HttpError) {
  case d {
    Ok(b) ->
      utils.key_exists(b, key)
      |> result.map_error(fn(_) {
        errors.new_bad_request() |> errors.set_message("Missing key" <> key)
      })
    Error(e) -> Error(e)
  }
}
