import gleam/dynamic
import gleam/erlang
import gleam/option
import infrastructure/queries
import infrastructure/sql
import infrastructure/where_clauses
import passwords/password
import sqlight
import users/criticals
import users/id
import utils

pub opaque type User {
  User(criticals: criticals.Criticals, username: String, created_at: Int)
}

/// Create a new user
pub fn new(id id: String, password p: String, username username: String) -> User {
  let id =
    id
    |> id.from_string

  let p =
    p
    |> password.from(fn(p) { p })

  let criticals: criticals.Criticals = criticals.new(id, p)
  User(
    criticals: criticals,
    username: username,
    created_at: erlang.erlang_timestamp() |> utils.extract_last_tuple3,
  )
}

fn id(user: User) -> BitArray {
  case user {
    User(cs, ..) -> cs |> criticals.id |> id.as_bit_array
  }
}

fn password(user: User) -> String {
  case user {
    User(cs, ..) -> cs |> criticals.password |> password.to_string
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
pub fn save(user: User, db database: option.Option(sql.DatabaseName)) {
  let query =
    "INSERT INTO users (id, password, username, created_at) VALUES (?, ?, ?, ?)"
  sql.ask(
    db: database |> option.unwrap(sql.memory),
    query: query,
    decoder: decoder(),
    arguments: [
      sqlight.blob(id(user)),
      sqlight.text(password(user)),
      sqlight.text(username(user)),
      sqlight.int(created_at(user)),
    ],
  )
}

// TODO: move to infrastructure
/// Find a user by id
pub fn find(user: User, where database: sql.DatabaseName) {
  let q =
    queries.new_query(queries.Select([]), "users", [
      where_clauses.new("id", "=", id(user) |> sqlight.blob),
    ])

  sql.ask_with_query(db: database, query: q, decoder: decoder())
}

pub fn find_all(database: sql.DatabaseName) {
  let query = "SELECT * FROM users"
  sql.ask(db: database, query: query, decoder: decoder(), arguments: [])
}

fn decoder() {
  dynamic.tuple3(dynamic.bit_array, dynamic.string, dynamic.int)
}
