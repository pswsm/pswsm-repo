import gleam/dict
import gleam/dynamic
import gleam/http/request
import gleam/http/response
import gleam/int
import gleam/json
import gleam/list
import gleam/option
import gleam/result
import http/http_errors as errors
import mist
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
  |> result.map_error(fn(_) { errors.bad_request(option.Some("Invalid JSON")) })
}

pub fn validate_body_fields(
  d: Result(dict.Dict(String, String), errors.HttpError),
  keys: List(String),
) -> Result(dict.Dict(String, String), errors.HttpError) {
  keys
  |> list.fold(d, fn(acc, key) { validate_body_key(acc, key) })
}

fn validate_body_key(
  target_dict d: Result(dict.Dict(String, String), errors.HttpError),
  key key: String,
) -> Result(dict.Dict(String, String), errors.HttpError) {
  use target_dict <- utils.if_error(d, fn(e) { Error(e) })
  use _ <- utils.if_error(utils.get_key(target_dict, key), fn(e) {
    Error(errors.bad_request(option.Some(e)))
  })
  d
}

pub fn get_key_error(
  message error: String,
) -> response.Response(mist.ResponseData) {
  errors.bad_request(option.Some(error))
  |> errors.to_response
}
