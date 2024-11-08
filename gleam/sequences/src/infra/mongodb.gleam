import bison/bson
import gleam/erlang/process
import gleam/http/request
import gleam/httpc
import gleam/io
import gleam/json.{type Json}
import infra/infra_errors
import mungo
import utils

pub fn get_doc(
  from collection: String,
  by data: #(String, bson.Value),
) -> Result(bson.Value, infra_errors.InfrastructureError) {
  use connection <- start("localhost:27017")
  let collection = mungo.collection(connection, collection)
  use maybe_document <- utils.if_error(
    mungo.find_one(collection, [data], [], 500),
    fn(_) { Error(infra_errors.new_read_error("Failed to find")) },
  )
  use document <- utils.if_none(maybe_document, fn() {
    Error(infra_errors.new_read_error("Document not found"))
  })
  io.debug("Found document: ")
  io.debug(document)
  document |> Ok
}

pub fn persist_doc(
  to uri: String,
  this document: Json,
) -> Result(String, infra_errors.InfrastructureError) {
  io.debug("Persisting document on " <> uri)
  // use auth <- authenticate()
  use req <- utils.if_error(request.to(uri), fn(_) {
    Error(infra_errors.new_save_error("Failed to create request"))
  })
  let req_with_headers =
    request.prepend_header(req, "content-type", "application/json")
    |> request.prepend_header("accept", "application/json")
    |> request.set_body(document |> json.to_string)
  // |> request.set_cookie("AuthSession", auth)
  use _res <- utils.if_error(httpc.send(req_with_headers), fn(_) {
    Error(infra_errors.new_save_error("Failed to get response"))
  })
  Error(infra_errors.unknown_error("Not implemented"))
}

fn start(
  connection uri: String,
  cont callback: fn(process.Subject(_)) ->
    Result(b, infra_errors.InfrastructureError),
) -> Result(b, infra_errors.InfrastructureError) {
  use client <- utils.if_error(mungo.start(uri, 300), fn(_) {
    Error(infra_errors.new_read_error("Failed to start http client"))
  })

  callback(client)
}
