import gleam/list
import gleam/result
import infra/queries
import infra/sql
import infra/where_clauses
import sqlight
import users/id
import users/user_errors
import users/users.{type User}
import utils

/// Find a user by id
pub fn get(id id: id.UserId) -> Result(users.User, user_errors.UserError) {
  let q =
    queries.new_query(queries.Select([]), "users", [
      where_clauses.new("id", "=", id |> id.as_bit_array |> sqlight.blob),
    ])

  sql.ask_with_query(query: q, decoder: users.decoder())
  // TODO: lost error traceability here, fix this
  |> result.map_error(fn(_) { Nil })
  |> result.try(fn(users) { users |> list.first() })
  |> result.map_error(fn(_) { user_errors.user_not_found(id |> id.as_string) })
  |> result.try(fn(user) { user |> users.from_tuple |> Ok })
}

pub fn find() -> Result(List(User), user_errors.UserError) {
  let query = queries.new_query(queries.Select([]), "users", [])
  sql.ask_with_query(query: query, decoder: users.decoder())
  |> result.try(fn(users) {
    users
    |> list.map(fn(user) { user |> users.from_tuple })
    |> Ok
  })
  |> result.map_error(user_errors.from_sql)
}

pub fn get_by_username(
  username u: String,
) -> Result(User, user_errors.UserError) {
  let q =
    queries.new_query(queries.Select([]), "users", [
      where_clauses.new("username", "=", u |> sqlight.text),
    ])

  sql.ask_with_query(query: q, decoder: users.decoder())
  |> result.map_error(fn(_) { Nil })
  |> result.try(fn(users) { users |> list.first() })
  |> result.map_error(fn(_) { user_errors.user_not_found(u) })
  |> result.try(fn(user) { user |> users.from_tuple |> Ok })
}
