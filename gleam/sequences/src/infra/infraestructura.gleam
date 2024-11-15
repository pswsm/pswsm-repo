import gleam/erlang/os
import gleam/json
import gleam/option
import gleam/result
import gleam/string
import infra/couchdb
import infra/find_users_mapper
import infra/infra_errors
import users/users
import utils

// TODO Type uri as Uri and not String
pub opaque type Infraestructura {
  CouchDB(uri: String, extra_path: option.Option(String))
}

fn merge_uri(uri: String, extra_path: option.Option(String)) -> String {
  case extra_path {
    option.None -> uri
    option.Some(path) -> uri <> path
  }
}

pub fn connect_couch(
  extra path: String,
  use_callback cb: fn(Infraestructura) -> a,
) -> a {
  let assert Ok(uri) = os.get_env("COUCHDB_URI")

  case path {
    "" -> {
      CouchDB(uri, option.None) |> cb
    }
    _ -> {
      let extra_path = case string.starts_with(path, "/") {
        True -> option.Some(path)
        False -> option.Some("/" <> path)
      }

      CouchDB(uri, extra_path) |> cb
    }
  }
}

pub fn find(
  which infra: Infraestructura,
  asking_for what: #(String, String),
) -> Result(List(users.User), String) {
  case infra {
    CouchDB(uri, path) -> {
      use docs <- utils.if_error(
        couchdb.find(merge_uri(uri, path), what),
        fn(infra_error) { infra_error |> infra_errors.get_message |> Error },
      )
      use matching_docs <- utils.if_error(find_users_mapper.map(docs), fn(_) {
        "unknown error aaaaaaaaaa" |> Error
      })
      Ok(matching_docs)
    }
  }
}

pub fn get_by_id(
  from infra: Infraestructura,
  id id: String,
  using constructor: fn(String) -> b,
) -> Result(b, String) {
  case infra {
    CouchDB(uri, path) -> {
      use doc <- utils.if_error(
        couchdb.get(merge_uri(uri, path), id),
        fn(infra_error) { infra_error |> infra_errors.get_message |> Error },
      )
      Ok(constructor(doc))
    }
  }
}

pub fn persist(
  which infra: Infraestructura,
  saving doc: json.Json,
) -> Result(String, String) {
  case infra {
    CouchDB(uri, extra_path) -> {
      couchdb.persist_doc(merge_uri(uri, extra_path), doc)
      |> result.map_error(infra_errors.get_message(_))
    }
  }
}
