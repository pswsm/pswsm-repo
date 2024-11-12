import gleam/json
import gleam/result
import infra/couchdb
import infra/infra_errors

// TODO Type uri as Uri and not String
pub opaque type Infraestructura {
  CouchDB(uri: String)
}

pub fn connect_couch(use_callback cb: fn(Infraestructura) -> a) -> a {
  CouchDB("http://localhost:5984") |> cb
}

pub fn get(
  which infra: Infraestructura,
  on db: String,
  asking_for what: #(String, String),
) -> Result(String, String) {
  case infra {
    CouchDB(uri) -> {
      couchdb.get_doc(uri, db, what)
      |> result.map_error(infra_errors.get_message(_))
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
