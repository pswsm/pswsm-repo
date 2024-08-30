import gleam/dynamic
import gleam/io
import gleam/option
import sqlight

pub opaque type DatabaseName {
  LocalDb(String)
  Memory
  Custom(String)
}

pub fn choose(election: String) -> DatabaseName {
  case election {
    "localdb" -> LocalDb("localdb")
    "memory" -> Memory
    _ -> Custom(election)
  }
}

pub fn name(database: DatabaseName) -> String {
  case database {
    LocalDb(name) -> name
    Memory -> ":memory:"
    Custom(name) -> name
  }
}

pub const localdb = LocalDb("localdb")

pub const memory = Memory

pub fn ask(
  db database: DatabaseName,
  query what: String,
  fill with: option.Option(List(_)),
  decoder format: fn(dynamic.Dynamic) -> Result(a, List(dynamic.DecodeError)),
) {
  let fill = option.unwrap(with, [])
  use connection <- sqlight.with_connection(database |> name)

  io.debug("Asking: " <> what)

  case sqlight.query(what, connection, fill, format) {
    Ok(result) -> result
    _ -> panic
  }
}

pub fn order(db database: DatabaseName, query what: String) {
  io.debug("Ordering \"" <> what <> "\" from \"" <> database |> name <> "\"")
  use connection <- sqlight.with_connection(database |> name)

  sqlight.exec(what, connection)
}
