import gleam/erlang/os
import gleam/list
import infra/infra_errors
import sqlight
import users/decoder
import users/id
import users/users
import utils

pub fn find_by_id(
  id: id.UserId,
) -> Result(users.User, infra_errors.InfrastructureError) {
  let assert Ok(db_path) = os.get_env("DB_PATH")
  use conn <- sqlight.with_connection(db_path)

  use users <- utils.if_error(
    sqlight.query(
      "select * from users where id = ?;",
      conn,
      [sqlight.text(id.value_of(id))],
      decoder.decode(),
    ),
    fn(e) { infra_errors.ReadError(e.message) |> Error },
  )

  use user <- utils.if_error(list.first(users), fn(_: Nil) {
    infra_errors.NotFoundError("User not found") |> Error
  })

  Ok(user)
}
