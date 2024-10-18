import auth/token
import gleam/bool
import gleam/erlang
import gleam/result
import timestamps/timestamp
import users/user_finder
import users/users

pub type AuthError {
  AuthError(String)
}

pub fn auth(username u: String) -> Result(String, AuthError) {
  let current_time =
    erlang.system_time(erlang.Millisecond) |> timestamp.from_millis

  user_finder.get_by_username(u)
  |> result.map_error(fn(_) { AuthError("User not found") })
  |> result.map(fn(user) {
    token.new(user |> users.username, current_time |> timestamp.add_hours(12))
  })
  |> result.map(fn(token) { token |> token.tokenize })
}

pub fn can_access(string_token t: String) -> Bool {
  use <- bool.guard(token.from_string(t) |> result.is_error, False)
  let token =
    token.from_string(t)
    |> result.unwrap(token.new("", timestamp.from_millis(0)))
  use <- bool.guard(token |> token.is_valid |> bool.negate, False)
  True
}
