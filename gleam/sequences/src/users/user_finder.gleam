import infra/infraestructura
import users/user_errors
import users/username
import users/users
import utils

pub fn get_by_username(
  identifier username: username.Username,
) -> Result(users.User, user_errors.UserError) {
  use infra <- infraestructura.connect_couch()
  use user <- utils.if_error(
    infra
      |> infraestructura.get("users", #("username", username.value_of(username))),
    fn(error) { Error(user_errors.user_not_found(error)) },
  )
  user |> Ok
}
