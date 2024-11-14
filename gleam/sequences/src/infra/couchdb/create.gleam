import gleam/http/request
import gleam/http/response
import gleam/httpc
import gleam/json
import gleam/result
import infra/infra_errors
import utils

pub fn document(
  this document: json.Json,
  on_remote uri: String,
  with_auth cookie: String,
) -> Result(response.Response(String), infra_errors.InfrastructureError) {
  use req <- utils.if_error(request.to(uri), fn(_) {
    Error(infra_errors.UknownError("Failed to create request"))
  })
  let req_with_headers =
    request.prepend_header(req, "content-type", "application/json")
    |> request.prepend_header("accept", "application/json")
    |> request.set_body(document |> json.to_string)
    |> request.set_cookie("AuthSession", cookie)

  httpc.send(req_with_headers)
  |> result.map_error(fn(_) { infra_errors.SaveError("Failed to send request") })
}
