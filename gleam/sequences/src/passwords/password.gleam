import ffi/hash
import gleam/json
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

pub fn to_string(p: Password) -> String {
  case p {
    Password(s) -> s
  }
}

pub fn to_json(p: Password) -> json.Json {
  p |> to_string |> json.string
}
