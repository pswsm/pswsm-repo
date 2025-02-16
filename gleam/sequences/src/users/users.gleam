import gleam/json
import timestamps
import users/id
import users/password
import users/username

pub opaque type User {
  User(
    user_id: id.UserId,
    username: username.Username,
    password: password.Password,
    created_at: timestamps.Timestamp,
  )
}

/// Create a new user
pub fn new(
  user_id id: id.UserId,
  username username: username.Username,
  password p: password.Password,
) -> User {
  User(id, username, password: p, created_at: timestamps.new())
}

pub fn get_id(user: User) -> id.UserId {
  user.user_id
}

pub fn get_password(user: User) -> password.Password {
  user.password
}

pub fn get_username(user: User) -> username.Username {
  user.username
}

pub fn from_primitves(
  id: String,
  username: String,
  password: String,
  created_at: Int,
) -> User {
  let password = password.from(password, fn(p) { p })
  User(
    id.from_string(id),
    username.new(username),
    password,
    created_at: timestamps.from_millis(created_at),
  )
}

/// Convert a user to a JSON-compatible object
///
/// Example:
/// ```gleam
/// let user = new("alice", "password")
/// to_primitives(user)
/// // -> [{"_id": "alice", "password": "password", "created_at": 123456789}]
/// ```
pub fn to_primitives(this user: User) {
  [
    #("_id", get_id(user) |> id.value_of |> json.string),
    #("username", get_username(user) |> username.value_of |> json.string),
    #("password", get_password(user) |> password.value_of |> json.string),
    #("created_at", user.created_at |> timestamps.value_of |> json.int),
  ]
}

pub fn parts(
  of this: User,
) -> #(id.UserId, username.Username, password.Password, timestamps.Timestamp) {
  #(get_id(this), get_username(this), get_password(this), this.created_at)
}
