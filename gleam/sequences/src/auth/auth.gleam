import auth/token
import gleam/bool
import gleam/erlang
import gleam/result
import timestamps
import users/user_errors
import users/user_finder
import users/username
import users/users

pub type AuthError {
  AuthError(String)
}

pub fn auth(username u: String) -> Result(String, AuthError) {
  let current_time =
    erlang.system_time(erlang.Millisecond) |> timestamps.from_millis

  user_finder.get_by_username(username.new(u))
  |> result.map_error(fn(error) { AuthError(user_errors.message(error)) })
  |> result.map(fn(user) {
    token.new(
      user |> users.get_id,
      user |> users.get_username,
      current_time |> timestamps.add_hours(12),
    )
  })
  |> result.map(fn(token) { token |> token.to_jwt })
}

pub fn can_access(token t: token.Token) -> Bool {
  use <- bool.guard(t |> token.is_valid, True)
  False
}
