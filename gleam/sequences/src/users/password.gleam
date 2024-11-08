import ffi/hash
import gleam/result

pub opaque type Password {
  Password(String)
}

pub fn new(password: String) -> Password {
  Password(password |> hash.hash |> result.unwrap_both)
}

pub fn from(f: a, transform: fn(a) -> String) {
  Password(transform(f))
}

pub fn value_of(p: Password) -> String {
  case p {
    Password(s) -> s
  }
}
