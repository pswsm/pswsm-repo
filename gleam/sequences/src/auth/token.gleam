import gleam/dynamic
import gleam/json
import gwt
import timestamps
import users/id
import users/username
import users/users
import utils

pub opaque type Token {
  Token(
    id: id.UserId,
    username: username.Username,
    expiry: timestamps.Timestamp,
  )
}

pub fn new(
  for user: users.User,
  valid_till expiry: timestamps.Timestamp,
) -> Token {
  Token(users.get_id(user), users.get_username(user), expiry)
}

fn get_id(token t: Token) -> id.UserId {
  t.id
}

fn get_username(token t: Token) -> username.Username {
  t.username
}

fn get_expiry(token t: Token) -> timestamps.Timestamp {
  t.expiry
}

pub fn to_jwt(token: Token) -> String {
  let id = get_id(token)
  let username = get_username(token) |> username.value_of |> json.string
  let expiry = get_expiry(token) |> timestamps.value_of

  gwt.new()
  |> gwt.set_subject(id |> id.value_of)
  |> gwt.set_expiration(expiry)
  |> gwt.set_issuer("pswsm.cat")
  |> gwt.set_issued_at(timestamps.new() |> timestamps.value_of)
  |> gwt.set_payload_claim("username", username)
  // TODO: secret on .env
  |> gwt.to_signed_string(gwt.HS256, "secret")
}

pub fn is_valid(token t: Token) -> Bool {
  t |> get_expiry |> timestamps.is_future
}

pub fn from_jwt(jwt: String) -> Result(Token, String) {
  // TODO: secret on .env
  use decoded <- utils.if_error(jwt |> gwt.from_signed_string("secret"), fn(_) {
    Error("Invalid token")
  })
  use id <- utils.if_error(gwt.get_subject(decoded), fn(_) {
    Error("Invalid token")
  })
  use username <- utils.if_error(
    gwt.get_payload_claim(decoded, "username", dynamic.string),
    fn(_) { Error("Invalid token") },
  )
  use expiry <- utils.if_error(gwt.get_expiration(decoded), fn(_) {
    Error("Invalid token")
  })

  Token(
    id.from_string(id),
    username.new(username),
    timestamps.from_millis(expiry),
  )
  |> Ok
}
