import gleam/dynamic
import gleam/erlang
import gleam/json
import gleam/list
import gleam/result
import infra/queries
import infra/sql
import infra/where_clauses
import passwords/password
import sqlight
import users/criticals
import users/id
import users/user_errors as errors

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

pub fn save(user: User) -> Result(_, errors.UserError) {
  let query =
    "INSERT INTO users (id, password, username, created_at) VALUES (?, ?, ?, ?)"
  sql.ask(query: query, decoder: decoder(), arguments: [
    sqlight.blob(id(user) |> id.as_bit_array),
    sqlight.text(password(user) |> password.to_string),
    sqlight.text(username(user)),
    sqlight.int(created_at(user)),
  ])
  |> result.map_error(errors.from_sql)
}

/// Find a user by id
pub fn get(id id: id.UserId) -> Result(User, errors.UserError) {
  let q =
    queries.new_query(queries.Select([]), "users", [
      where_clauses.new("id", "=", id |> id.as_bit_array |> sqlight.blob),
    ])

  sql.ask_with_query(query: q, decoder: decoder())
  // TODO: lost error traceability here, fix this
  |> result.map_error(fn(_) { Nil })
  |> result.try(fn(users) { users |> list.first() })
  |> result.map_error(fn(_) { errors.user_not_found(id) })
  |> result.try(fn(user) { user |> from_tuple |> Ok })
}

pub fn find_all() -> Result(List(User), errors.UserError) {
  let query = "SELECT * FROM users"
  sql.ask(query: query, decoder: decoder(), arguments: [])
  |> result.try(fn(users) {
    users
    |> list.map(fn(user) { from_primitves(user.0, user.1, user.2, user.3) })
    |> Ok
  })
  |> result.map_error(errors.from_sql)
}

fn decoder() {
  dynamic.tuple4(dynamic.bit_array, dynamic.string, dynamic.string, dynamic.int)
}

fn from_tuple(t: #(BitArray, String, String, Int)) -> User {
  from_primitves(t.0, t.1, t.2, t.3)
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
