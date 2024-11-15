import gleam/json
import users/decoder
import users/users

pub fn map(doc: String) -> Result(users.User, json.DecodeError) {
  json.decode(doc, decoder.decode())
}
