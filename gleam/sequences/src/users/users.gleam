import gleam/dynamic
import gleam/erlang
import gleam/json
import gleam/list
import gleam/option
import gleam/result
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
    created_at: erlang.system_time(erlang.Millisecond),
  )
}

fn id(user: User) -> id.UserId {
  case user {
    User(cs, ..) -> cs |> criticals.id
  }
}

fn password(user: User) -> password.Password {
  case user {
    User(cs, ..) -> cs |> criticals.password
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

pub fn save(user: User, db database: option.Option(sql.DatabaseName)) {
  let query =
    "INSERT INTO users (id, password, username, created_at) VALUES (?, ?, ?, ?)"
  sql.ask(
    db: database |> option.unwrap(sql.memory),
    query: query,
    decoder: decoder(),
    arguments: [
      sqlight.blob(id(user) |> id.as_bit_array),
      sqlight.text(password(user) |> password.to_string),
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
      where_clauses.new("id", "=", id(user) |> id.as_bit_array |> sqlight.blob),
    ])

  sql.ask_with_query(db: database, query: q, decoder: decoder())
}

pub fn find_all(database: sql.DatabaseName) {
  let query = "SELECT * FROM users"
  sql.ask(db: database, query: query, decoder: decoder(), arguments: [])
  |> result.try(fn(users) {
    users
    |> list.map(fn(user) { from_primitves(user.0, user.1, user.2, user.3) })
    |> Ok
  })
}

fn decoder() {
  dynamic.tuple4(dynamic.bit_array, dynamic.string, dynamic.string, dynamic.int)
}

fn from_primitves(
  id: BitArray,
  password: String,
  username: String,
  created_at: Int,
) {
  User(
    criticals: criticals.new(
      id.from_bit_array(id),
      password.from(password, fn(p) { p }),
    ),
    username: username,
    created_at: created_at,
  )
}

pub fn to_resource(user: User) {
  [
    #("id", id(user) |> id.to_json),
    #("password", password(user) |> password.to_json),
    #("username", username(user) |> json.string),
    #("created_at", created_at(user) |> json.int),
  ]
  |> json.object
}
