import gleam/int
import sqlight

pub opaque type SqlError {
  SaveError(message: String)
  ReadError(message: String)
  UknownError(message: String)
}

pub fn new_save_error(info message: String) -> SqlError {
  SaveError(message)
}

pub fn new_read_error(info message: String) -> SqlError {
  ReadError(message)
}

fn unknown_error(message message: String) -> SqlError {
  UknownError(message)
}

pub fn get_message(error: SqlError) -> String {
  case error {
    SaveError(message) -> message
    ReadError(message) -> message
    UknownError(message) -> message
  }
}

pub fn from(error: sqlight.Error) -> SqlError {
  case error {
    sqlight.SqlightError(code, message, _offset) -> from_code(code, message)
  }
}

fn from_code(code: sqlight.ErrorCode, message: String) -> SqlError {
  let code_str: String = sqlight.error_code_to_int(code) |> int.to_string
  unknown_error(message: code_str <> ": " <> message)
}
