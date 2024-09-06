pub opaque type SqlError {
  SaveError(message: String)
  ReadError(message: String)
}

pub fn new_save_error(info message: String) -> SqlError {
  SaveError(message)
}

pub fn new_read_error(info message: String) -> SqlError {
  ReadError(message)
}

pub fn get_message(error: SqlError) -> String {
  case error {
    SaveError(message) -> message
    ReadError(message) -> message
  }
}
