import auth/token
import ffi/verify
import gleam/bool
import kernel/logger
import timestamps
import users/password
import users/users
import utils

pub type AuthError {
  AuthError(message: String)
}

pub fn get_message(from error: AuthError) -> String {
  error.message
}

pub fn auth(
  user u: users.User,
  password p: password.Password,
) -> Result(String, AuthError) {
  let user_password = users.get_password(u)
  let validity: timestamps.Timestamp =
    timestamps.new() |> timestamps.add_hours(1)

  use verify_result <- utils.if_error(
    verify.verify(password.value_of(p), password.value_of(user_password)),
    fn(e) {
      logger.debug(e)
      AuthError("could not verify password") |> Error
    },
  )

  case verify_result {
    True -> token.new(u, validity) |> token.to_jwt |> Ok
    False -> AuthError("password incorrect") |> Error
  }
}

pub fn can_access(token t: token.Token) -> Bool {
  use <- bool.guard(t |> token.is_valid, True)
  False
}
