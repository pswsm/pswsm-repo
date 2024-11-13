import gleam/http
import gleam/http/request
import gleam/http/response
import gleam/httpc
import infra/infra_errors
import utils

pub fn document(
  from uri: String,
  on db: String,
  matching id: String,
  with cookie: String,
) -> Result(response.Response(String), infra_errors.InfrastructureError) {
  use req <- utils.if_error(request.to(uri <> "/" <> db <> "/" <> id), fn(_) {
    Error(infra_errors.new_read_error("Failed to create request"))
  })
  let req_with_headers =
    request.prepend_header(req, "accept", "application/json")
    |> request.prepend_header("content-type", "application/json")
    |> request.set_cookie("AuthSession", cookie)
    |> request.set_method(http.Get)

  use res <- utils.if_error(httpc.send(req_with_headers), fn(_) {
    Error(infra_errors.new_read_error("Failed to get response"))
  })
  Ok(res)
}
