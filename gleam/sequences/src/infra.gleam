import gleam/dynamic
import gleam/io
import gleam/option
import sqlight

pub const localdb = "localdb"

pub const memory = ":memory:"

pub fn ask(
  who table: String,
  query what: String,
  fill with: option.Option(List(_)),
  decoder format: fn(dynamic.Dynamic) -> Result(a, List(dynamic.DecodeError)),
) {
  let fill = option.unwrap(with, [])
  use connection <- sqlight.with_connection(table)

  io.debug("Asking: " <> what)

  case sqlight.query(what, connection, fill, format) {
    Ok(result) -> result
    _ -> panic
  }
}

pub fn order(who conn: String, query what: String) {
  io.debug("Ordering: " <> what)
  io.debug("From: " <> conn)
  use connection <- sqlight.with_connection(conn)

  sqlight.exec(what, connection)
}
