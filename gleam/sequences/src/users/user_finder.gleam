import gleam/result
import infra/infraestructura
import users/constants
import users/user_errors
import users/username
import users/users

pub fn get_by_username(
  identifier username: username.Username,
) -> Result(users.User, user_errors.UserError) {
  use infra <- infraestructura.connect_couch(constants.global_users_source)

  infra
  |> infraestructura.find(#("username", username.value_of(username)))
  |> result.map_error(user_errors.user_not_found)
}
