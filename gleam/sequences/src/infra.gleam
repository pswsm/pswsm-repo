import gleam/dynamic
import sqlight

pub const localdb = "localdb"

pub const memory = ":memory:"

pub fn ask(
  who: String,
  what: String,
  with: List(_),
  format: fn(dynamic.Dynamic) -> Result(a, List(dynamic.DecodeError)),
) {
  use connection <- sqlight.with_connection(who)

  case sqlight.query(what, connection, with, format) {
    Ok(result) -> result
    _ -> panic
  }
}
