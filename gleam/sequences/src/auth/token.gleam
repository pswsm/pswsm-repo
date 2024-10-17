import gleam/string_builder
import timestamps/timestamp.{type Timestamp}

pub opaque type Token {
  Token(username: String, expiry: Timestamp)
}

pub fn new(username: String, expiry: Timestamp) -> Token {
  Token(username, expiry)
}

fn get_username(token t: Token) -> String {
  case t {
    Token(username, _) -> username
  }
}

fn get_expiry(token t: Token) -> Timestamp {
  case t {
    Token(_, expiry) -> expiry
  }
}

pub fn tokenize(token: Token) -> String {
  token
  |> get_username
  |> string_builder.from_string
  |> string_builder.append("+")
  |> string_builder.append(get_expiry(token) |> timestamp.to_sting)
  |> string_builder.to_string
}
