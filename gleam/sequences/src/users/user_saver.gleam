import gleam/json
import infra/infraestructura
import users/user_errors
import users/users.{type User}
import utils

pub fn save(this user: User) -> Result(String, user_errors.UserError) {
  use infra <- infraestructura.connect_couch()
  use persist <- utils.if_error(
    infraestructura.persist(infra, user |> users.to_primitives |> json.object),
    fn(error) { Error(user_errors.generic_user_error(error)) },
  )
  Ok(persist)
}
