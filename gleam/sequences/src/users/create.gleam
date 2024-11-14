import gleam/json
import infra/infraestructura
import users/constants
import users/user_errors
import users/users.{type User}
import utils

pub fn create(this user: User) -> Result(String, user_errors.UserError) {
  use infra <- infraestructura.connect_couch(constants.global_users_source)
  use persist <- utils.if_error(
    infraestructura.persist(infra, user |> users.to_primitives |> json.object),
    fn(error) { Error(user_errors.generic_user_error(error)) },
  )
  Ok(persist)
}
