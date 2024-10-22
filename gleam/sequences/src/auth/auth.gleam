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

pub fn can_access(token t: token.Token) -> Bool {
  use <- bool.guard(t |> token.is_valid, True)
  False
}
