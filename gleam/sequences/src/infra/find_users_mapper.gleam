import gleam/dynamic
import gleam/json
import users/decoder
import users/users

pub fn map(map_this docs: String) -> Result(List(users.User), json.DecodeError) {
  json.decode(docs, dynamic.field("docs", dynamic.list(decoder.decode())))
}
