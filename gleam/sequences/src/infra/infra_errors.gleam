pub type InfrastructureError {
  SaveError(message: String)
  ReadError(message: String)
  PermissionsError(message: String)
  UknownError(message: String)
  NotFoundError(message: String)
}

pub fn get_message(error: InfrastructureError) -> String {
  error.message
}
