import gleam/dynamic
import gleam/int
import gleam/json
import gleam/list
import gleam/result
import infra/couchdb
import infra/infra_errors
import users/users
import utils

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
) -> Result(users.User, String) {
  case infra {
    CouchDB(uri) -> {
      use docs <- utils.if_error(
        couchdb.find_doc(uri, db, what),
        fn(infra_error) { infra_error |> infra_errors.get_message |> Error },
      )
      use matching_docs <- utils.if_error(
        docs
          |> json.decode(dynamic.field(
            "docs",
            dynamic.list(dynamic.decode4(
              users.from_primitves,
              dynamic.field("_id", dynamic.string),
              dynamic.field("username", dynamic.string),
              dynamic.field("password", dynamic.string),
              dynamic.field(
                "created_at",
                dynamic.any([
                  fn(ct) {
                    use string_ct <- utils.if_error(ct |> dynamic.string, fn(_) {
                      [
                        dynamic.DecodeError(
                          expected: "String",
                          found: "Int",
                          path: [],
                        ),
                      ]
                      |> Error
                    })

                    use int_ct <- utils.if_error(
                      string_ct
                        |> int.parse,
                      fn(_) {
                        [
                          dynamic.DecodeError(
                            expected: "Int",
                            found: "String",
                            path: ["created_at"],
                          ),
                        ]
                        |> Error
                      },
                    )
                    int_ct |> Ok
                  },
                ]),
              ),
            )),
          )),
        fn(_) { "unknown error aaaaaaaaaa" |> Error },
      )
      use first_doc <- utils.if_error(matching_docs |> list.first, fn(_) {
        "no matching docs" |> Error
      })
      use user <- utils.if_error(first_doc, fn(_) {
        "error decoding user" |> Error
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
