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

pub fn get_by_id(
  identifier id: id.UserId,
) -> Result(users.User, user_errors.UserError) {
  use infra <- infraestructura.connect_couch(constants.global_users_source)

  use maybe_user <- utils.if_error(
    {
      infra
      |> infraestructura.get_by_id(id: id.value_of(id), using: user_mapper.map)
      |> result.map_error(user_errors.user_not_found)
    },
    Error(_),
  )

  maybe_user
  |> result.map_error(fn(_) { user_errors.user_not_found(id.value_of(id)) })
}
