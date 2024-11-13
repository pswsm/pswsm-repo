import gleam/dict
import gleam/dynamic
import gleam/http/request
import gleam/http/response
import gleam/int
import gleam/json
import gleam/option
import gleam/result
import http/http_errors as errors
import mist

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

pub fn get_key_error(
  message error: String,
) -> response.Response(mist.ResponseData) {
  errors.bad_request(option.Some(error))
  |> errors.to_response
}
