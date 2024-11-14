import ffi/hash
import gleam/result

pub opaque type Password {
  Password(value: String)
}

pub type PasswordError {
  PasswordError(message: String)
}

pub fn new(password: String) -> Result(Password, PasswordError) {
  hash.hash(password)
  |> result.map(Password(_))
  |> result.map_error(PasswordError)
}

pub fn from(f: a, transform: fn(a) -> String) -> Password {
  Password(transform(f))
}

pub fn value_of(p: Password) -> String {
  p.value
}
