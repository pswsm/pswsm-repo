import gleam/erlang/os
import gleam/http
import gleam/http/request
import gleam/http/response
import gleam/httpc
import gleam/json.{type Json}
import gleam/list
import infra/couchdb/create
import infra/couchdb/find
import infra/couchdb/get
import infra/infra_errors
import utils

fn handle_response_codes(
  response res: response.Response(String),
) -> Result(String, infra_errors.InfrastructureError) {
  case res.status {
    200 | 201 -> Ok(res.body)
    401 -> Error(infra_errors.PermissionsError("Missing permissions"))
    404 -> Error(infra_errors.NotFoundError(res.body))
    _ -> Error(infra_errors.ReadError(res.body))
  }
}

pub fn find(
  from uri: String,
  matching pattern: #(String, String),
) -> Result(String, infra_errors.InfrastructureError) {
  use #(_, cookie) <- authenticate()
  use res <- utils.interrogant(find.document(uri, pattern, cookie))
  handle_response_codes(res)
}

pub fn get(
  from uri: String,
  id id: String,
) -> Result(String, infra_errors.InfrastructureError) {
  use #(_, cookie) <- authenticate()
  use res <- utils.interrogant(get.document(uri, id, cookie))
  handle_response_codes(res)
}

pub fn persist_doc(
  to uri: String,
  this document: Json,
) -> Result(String, infra_errors.InfrastructureError) {
  use #(_, auth) <- authenticate()
  use res <- utils.interrogant(create.document(document, uri, auth))
  handle_response_codes(res)
}

pub fn authenticate(
  continue callback: fn(#(String, String)) ->
    Result(b, infra_errors.InfrastructureError),
) -> Result(b, infra_errors.InfrastructureError) {
  let assert Ok(auth_base_uri) = os.get_env("COUCHDB_URI")
  let assert Ok(couchdb_username) = os.get_env("COUCHDB_USERNAME")
  let assert Ok(couchdb_password) = os.get_env("COUCHDB_PASSWORD")
  let auth_uri = auth_base_uri <> "/_session"
  use req <- utils.if_error(request.to(auth_uri), fn(_) {
    Error(infra_errors.UknownError("failed to authenticate"))
  })
  let prepared_request =
    req
    |> request.set_method(http.Post)
    |> request.prepend_header("accept", "application/json")
    |> request.prepend_header(
      "content-type",
      "application/x-www-form-urlencoded;charset=utf-8",
    )
    |> request.set_body(
      "name=" <> couchdb_username <> "&password=" <> couchdb_password,
    )

  use res <- utils.if_error(httpc.send(prepared_request), fn(_) {
    Error("failed to get response" |> infra_errors.UknownError)
  })

  use cookie <- utils.if_error(response.get_cookies(res) |> list.first, fn(_) {
    Error("failed to get cookie" |> infra_errors.UknownError)
  })

  callback(cookie)
}
