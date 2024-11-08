pub opaque type InfrastructureError {
  SaveError(message: String)
  ReadError(message: String)
  PermissionsError(message: String)
  UknownError(message: String)
}

pub fn new_save_error(info message: String) -> InfrastructureError {
  SaveError(message)
}

pub fn new_read_error(info message: String) -> InfrastructureError {
  ReadError(message)
}

pub fn unknown_error(info message: String) -> InfrastructureError {
  UknownError(message)
}

pub fn new_permissions_error(info message: String) -> InfrastructureError {
  PermissionsError(message)
}

pub fn get_message(error: InfrastructureError) -> String {
  error.message
}
