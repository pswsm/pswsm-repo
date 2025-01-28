import gleam/dynamic
import gleam/erlang/os
import gleam/list
import gleam/option
import gleam/string_builder
import infra/infra_errors
import sqlight
import utils

pub fn find_docs(
  on table: String,
  where pattern: List(String),
  contructor t: fn(dynamic.Dynamic) -> Result(a, dynamic.DecodeErrors),
) -> Result(a, infra_errors.InfrastructureError) {
  let assert Ok(db_path) = os.get_env("DB_PATH")
  use conn <- sqlight.with_connection(db_path)

  let sql =
    string_builder.from_string("select * from ") |> string_builder.append(table)

  let sql = case list.is_empty(pattern) {
    True -> sql |> string_builder.append(";")
    False ->
      sql
      |> string_builder.append(" ")
      |> string_builder.append(utils.implode(pattern, option.Some(", ")))
      |> string_builder.append(";")
  }

  use docs <- utils.if_error(
    sqlight.query(sql |> string_builder.to_string(), conn, [], t),
    fn(e) { infra_errors.ReadError(e.message) |> Error },
  )

  use user <- utils.if_error(list.first(docs), fn(_: Nil) {
    infra_errors.NotFoundError("User not found") |> Error
  })

  Ok(user)
}
