import infra/infra_errors

pub opaque type UserError {
  UserNotFound(String)
  GenericUserError(message: String)
}

pub fn user_not_found(identifier id: String) -> UserError {
  UserNotFound(id)
}

pub fn from_sql(error: infra_errors.SqlError) -> UserError {
  infra_errors.get_message(error) |> GenericUserError
}

pub fn message(error: UserError) -> String {
  case error {
    UserNotFound(id) -> "User not found: " <> id
    GenericUserError(message) -> message
  }
}
