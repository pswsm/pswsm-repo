import ffi/hash
import utils

pub opaque type Password {
  Password(String)
}

pub type PasswordError {
  PasswordError
}

pub fn new(password: String) -> Result(Password, PasswordError) {
  use hashed_password <- utils.if_error(hash.hash(password), fn(_) {
    Error(PasswordError)
  })
  hashed_password |> Password |> Ok
}

pub fn from(f: a, transform: fn(a) -> String) -> Password {
  Password(transform(f))
}

pub fn value_of(p: Password) -> String {
  case p {
    Password(s) -> s
  }
}
