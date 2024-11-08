import gleam/dynamic
import gleam/json
import infra/infraestructura
import users/user_errors
import users/username
import users/users
import utils

fn primitive_decoder() {
  dynamic.decode3(
    users.from_primitves,
    dynamic.field("_id", dynamic.string),
    dynamic.field("password", dynamic.string),
    dynamic.field("created_at", dynamic.int),
  )
}

pub fn get_by_username(
  identifier username: username.Username,
) -> Result(users.User, user_errors.UserError) {
  use infra <- infraestructura.connect_couch()
  use document <- utils.if_error(
    infra
      |> infraestructura.get("users", #("username", username.value_of(username))),
    fn(error) { Error(user_errors.user_not_found(error)) },
  )
  use user <- utils.if_error(
    json.decode(from: document, using: primitive_decoder()),
    fn(_) { Error(user_errors.user_not_found("User not found")) },
  )
  Ok(user)
}
