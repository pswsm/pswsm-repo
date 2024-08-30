import gleam/bit_array
import gleam/bytes_builder
import gleam/erlang
import gleam/int
import gleam/io
import gleam/option
import gleam/result
import gleam/string
import infra
import utils

pub opaque type User {
  User(id: BitArray, username: String, created_at: Int)
}

pub fn new(uuid id: String, username username: String) -> User {
  let id =
    id
    |> string.replace("-", "")
    |> bytes_builder.from_string
    |> bytes_builder.to_bit_array
  User(
    id: id,
    username: username,
    created_at: erlang.erlang_timestamp() |> utils.extract_last_tuple3,
  )
}

pub fn id(user: User) -> String {
  case user {
    User(id, ..) ->
      id |> bit_array.to_string |> result.lazy_unwrap(fn() { "invalid id" })
  }
}

pub fn username(user: User) -> String {
  case user {
    User(_, username, _) -> username
  }
}

pub fn created_at(user: User) -> Int {
  case user {
    User(_, _, created_at) -> created_at
  }
}

pub fn save(user: User, db database: option.Option(infra.DatabaseName)) {
  let query =
    "INSERT INTO users (id, username) VALUES (:id:, :username:, :created_at:)"
    |> string.replace(":id:", id(user))
    |> string.replace(":username:", username(user))
    |> string.replace(":created_at:", created_at(user) |> int.to_string)
  io.debug("saving user with \"" <> query <> "\"")
  infra.order(database |> option.unwrap(infra.memory), query)
}
