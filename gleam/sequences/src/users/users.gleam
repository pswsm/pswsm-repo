//// Module containing user utilities

import gleam/dynamic
import gleam/erlang
import gleam/int
import gleam/option
import gleam/string
import infrastructure/sql
import sqlight
import users/id
import utils

/// Type user
/// Has an id, a username and a creation date as a timestamp in ms
pub opaque type User {
  User(id: id.UserId, username: String, created_at: Int)
}

/// Create a new user
pub fn new(uuid id: String, username username: String) -> User {
  let id =
    id
    |> id.from_string
  User(
    id: id,
    username: username,
    created_at: erlang.erlang_timestamp() |> utils.extract_last_tuple3,
  )
}

/// The raw user id
fn raw_id(user: User) -> BitArray {
  case user {
    User(id, ..) -> id |> id.as_bit_array
  }
}

fn username(user: User) -> String {
  case user {
    User(_, username, _) -> username
  }
}

fn created_at(user: User) -> Int {
  case user {
    User(_, _, created_at) -> created_at
  }
}

// TODO: move to infrastructure
/// Save a user
pub fn save(user: User, db database: option.Option(sql.DatabaseName)) {
  let query =
    "INSERT INTO users (id, username, created_at) VALUES (?, ?, ?)"
    |> string.replace(":username:", username(user))
    |> string.replace(":created_at:", created_at(user) |> int.to_string)
  sql.ask(
    db: database |> option.unwrap(sql.memory),
    query: query,
    decoder: decoder(),
    arguments: [
      sqlight.blob(raw_id(user)),
      sqlight.text(username(user)),
      sqlight.int(created_at(user)),
    ],
  )
}

// TODO: move to infrastructure
/// Find a user by id
pub fn find(user: User, where database: sql.DatabaseName) {
  let query = "SELECT * FROM users WHERE id = ?"
  sql.ask(db: database, query: query, decoder: decoder(), arguments: [
    sqlight.blob(raw_id(user)),
  ])
}

/// Find all users
pub fn find_all(database: sql.DatabaseName) {
  let query = "SELECT * FROM users"
  sql.ask(db: database, query: query, decoder: decoder(), arguments: [])
}

fn decoder() {
  dynamic.tuple3(dynamic.bit_array, dynamic.string, dynamic.int)
}
