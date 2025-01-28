import gleam/erlang/os
import gleam/int
import gleam/result
import gleam/string_builder
import infra/infra_errors
import sqlight
import timestamps
import users/id
import users/password
import users/username
import users/users

pub fn create(user: users.User) -> Result(Nil, infra_errors.InfrastructureError) {
  let assert Ok(db_path) = os.get_env("DB_PATH")
  use conn <- sqlight.with_connection(db_path)
  let primitives: #(
    id.UserId,
    username.Username,
    password.Password,
    timestamps.Timestamp,
  ) = users.parts(user)
  let sql =
    string_builder.from_string("insert into users values ")
    |> string_builder.append(id.value_of(primitives.0))
    |> string_builder.append(username.value_of(primitives.1))
    |> string_builder.append(password.value_of(primitives.2))
    |> string_builder.append(timestamps.value_of(primitives.3) |> int.to_string)
    |> string_builder.to_string

  sqlight.exec(sql, conn)
  |> result.map_error(fn(e: sqlight.Error) { infra_errors.SaveError(e.message) })
}
