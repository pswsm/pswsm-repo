import gleam/erlang/os
import gleam/json
import gleam/list
import gleam/result
import infra/couchdb
import infra/find_users_mapper
import infra/infra_errors
import users/users
import utils

// TODO Type uri as Uri and not String
pub opaque type Infraestructura {
  CouchDB(uri: String)
}

pub fn connect_couch(use_callback cb: fn(Infraestructura) -> a) -> a {
  let assert Ok(uri) = os.get_env("COUCHDB_URI")

  CouchDB(uri) |> cb
}

pub fn find(
  which infra: Infraestructura,
  on db: String,
  asking_for what: #(String, String),
) -> Result(users.User, String) {
  case infra {
    CouchDB(uri) -> {
      use docs <- utils.if_error(couchdb.find(uri, db, what), fn(infra_error) {
        infra_error |> infra_errors.get_message |> Error
      })
      use matching_docs <- utils.if_error(find_users_mapper.map(docs), fn(_) {
        "unknown error aaaaaaaaaa" |> Error
      })
      use user <- utils.if_error(matching_docs |> list.first, fn(_) {
        "no matching docs" |> Error
      })
      user |> Ok
    }
  }
}

pub fn persist(
  which infra: Infraestructura,
  saving doc: json.Json,
) -> Result(String, String) {
  case infra {
    CouchDB(uri) -> {
      couchdb.persist_doc(uri, doc)
      |> result.map_error(infra_errors.get_message(_))
    }
  }
}
