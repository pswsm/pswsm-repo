import gleam/erlang/os
import gleam/http
import gleam/http/request
import gleam/http/response
import gleam/httpc
import gleam/int
import gleam/json.{type Json}
import gleam/list
import infra/infra_errors
import kernel/logger
import utils

fn handle_response_codes(
  response res: response.Response(String),
) -> Result(String, infra_errors.InfrastructureError) {
  case res.status {
    200 -> Ok(res.body)
    201 -> Ok(res.body)
    401 -> Error(infra_errors.new_permissions_error("Missing permissions"))
    404 -> Error(infra_errors.new_not_found_error(res.body))
    _ -> Error(infra_errors.new_read_error(res.body))
  }
}

pub fn get_doc(
  from uri: String,
  on db: String,
  matching pattern: #(String, String),
) -> Result(String, infra_errors.InfrastructureError) {
  use auth <- authenticate()
  use req <- utils.if_error(request.to(uri <> "/" <> db <> "/_find"), fn(_) {
    Error(infra_errors.new_read_error("Failed to create request"))
  })
  let req_with_headers =
    request.prepend_header(req, "accept", "application/json")
    |> request.prepend_header("content-type", "application/json")
    |> request.set_cookie("AuthSession", auth.1)
    |> request.set_method(http.Post)
    |> request.set_body(
      [
        #(
          "selector",
          [#(pattern.0, pattern.1 |> json.string)]
            |> json.object,
        ),
      ]
      |> json.object
      |> json.to_string,
    )
  logger.debug(req_with_headers.body)
  use res <- utils.if_error(httpc.send(req_with_headers), fn(_) {
    Error(infra_errors.new_read_error("Failed to get response"))
  })
  logger.debug(res.body)
  logger.debug(res.status |> int.to_string)
  handle_response_codes(res)
}

pub fn persist_doc(
  to uri: String,
  this document: Json,
) -> Result(String, infra_errors.InfrastructureError) {
  use auth <- authenticate()
  use req <- utils.if_error(request.to(uri), fn(_) {
    Error(infra_errors.new_save_error("Failed to create request"))
  })
  let req_with_headers =
    request.prepend_header(req, "content-type", "application/json")
    |> request.prepend_header("accept", "application/json")
    |> request.set_body(document |> json.to_string)
    |> request.set_cookie("AuthSession", auth.1)
  use res <- utils.if_error(httpc.send(req_with_headers), fn(_) {
    Error(infra_errors.new_save_error("Failed to get response"))
  })
  handle_response_codes(res)
}

fn authenticate(
  cont callback: fn(#(String, String)) ->
    Result(b, infra_errors.InfrastructureError),
) -> Result(b, infra_errors.InfrastructureError) {
  let assert Ok(auth_base_uri) = os.get_env("COUCHDB_URI")
  let auth_uri = auth_base_uri <> "/_session"
  logger.debug("authenticating with uri: " <> auth_uri)
  use req <- utils.if_error(request.to(auth_uri), fn(_) {
    Error(infra_errors.unknown_error("failed to authenticate"))
  })
  let prepared_request =
    req
    |> request.prepend_header(
      "content-type",
      "application/x-www-form-urlencoded;charset=utf-8",
    )
    |> request.prepend_header("accept", "application/json")
    |> request.set_body("name=admin&password=admin_password")
    |> request.set_method(http.Post)

  use res <- utils.if_error(httpc.send(prepared_request), fn(_) {
    Error("failed to get response" |> infra_errors.unknown_error)
  })

  use cookie <- utils.if_error(response.get_cookies(res) |> list.first, fn(_) {
    Error("failed to get cookie" |> infra_errors.unknown_error)
  })

  callback(cookie)
}
