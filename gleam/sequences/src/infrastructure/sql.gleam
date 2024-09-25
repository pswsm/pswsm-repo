import gleam/dynamic
import gleam/io
import infrastructure/queries
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
  arguments args: List(sqlight.Value),
  decoder format: fn(dynamic.Dynamic) -> Result(a, List(dynamic.DecodeError)),
) -> Result(List(a), sqlight.Error) {
  use connection <- sqlight.with_connection(database |> name)

  io.debug("Asking: " <> what)

  case sqlight.query(what, connection, args, format) {
    Ok(result) -> Ok(result)
    Error(error) -> Error(error)
  }
}

pub fn ask_with_query(
  db database: DatabaseName,
  query what: queries.Query,
  decoder format: fn(dynamic.Dynamic) -> Result(a, List(dynamic.DecodeError)),
) -> Result(List(a), sqlight.Error) {
  let q = what |> queries.build
  use connection <- sqlight.with_connection(database |> name)

  io.debug("Asking: " <> q.0)

  // README: use sqlight args for typesafety
  case sqlight.query(q.0, connection, q.1, format) {
    Ok(result) -> Ok(result)
    Error(error) -> Error(error)
  }
}

pub fn order(db database: DatabaseName, query what: String) {
  io.debug("Ordering \"" <> what <> "\" from \"" <> database |> name <> "\"")
  use connection <- sqlight.with_connection(database |> name)

  sqlight.exec(what, connection)
}
