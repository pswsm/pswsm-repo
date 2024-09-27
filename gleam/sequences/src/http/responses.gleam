import gleam/bytes_builder
import gleam/http/response
import gleam/json
import gleam/string_builder
import mist

pub fn base_response() -> response.Response(String) {
  response.new(200)
  |> response.set_header("Content-Type", "application/json")
}

pub fn with_json_body(
  res: response.Response(_),
  body: json.Json,
) -> response.Response(String) {
  res
  |> response.set_body(
    body |> json.to_string_builder |> string_builder.to_string,
  )
}

pub fn to_mist(
  res: response.Response(String),
) -> response.Response(mist.ResponseData) {
  res
  |> response.map(fn(body) { mist.Bytes(body |> bytes_builder.from_string) })
}
