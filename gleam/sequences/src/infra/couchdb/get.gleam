import gleam/http
import gleam/http/request
import gleam/http/response
import gleam/httpc
import gleam/result
import infra/infra_errors
import utils

pub fn document(
  from uri: String,
  matching id: String,
  with cookie: String,
) -> Result(response.Response(String), infra_errors.InfrastructureError) {
  use req <- utils.if_error(request.to(uri <> "/" <> id), fn(_) {
    Error(infra_errors.ReadError("Failed to create request"))
  })
  let req_with_headers =
    request.prepend_header(req, "accept", "application/json")
    |> request.prepend_header("content-type", "application/json")
    |> request.set_cookie("AuthSession", cookie)
    |> request.set_method(http.Get)

  httpc.send(req_with_headers)
  |> result.map_error(fn(_) { infra_errors.ReadError("Failed to get response") })
}
