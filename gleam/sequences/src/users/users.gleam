import gleam/json
import timestamps/timestamp
import users/criticals
import users/password
import users/username

pub opaque type User {
  User(core: criticals.Core, created_at: timestamp.Timestamp)
}

/// Create a new user
pub fn new(username id: String, password p: String) -> User {
  let id = username.new(id)
  let p = password.new(p)

  let criticals = criticals.new(id, p)
  User(core: criticals, created_at: timestamp.new())
}

fn get_password(user: User) -> password.Password {
  user.core |> criticals.get_password
}

pub fn get_username(user: User) -> username.Username {
  user.core |> criticals.get_username
}

pub fn from_primitves(
  username: String,
  password: String,
  created_at: Int,
) -> User {
  User(
    core: criticals.new(username.new(username), password.new(password)),
    created_at: timestamp.from_millis(created_at),
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
    #("_id", get_username(user) |> username.value_of |> json.string),
    #("password", get_password(user) |> password.value_of |> json.string),
    #("created_at", user.created_at |> timestamp.value_of |> json.int),
  ]
}
