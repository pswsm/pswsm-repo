import users/password
import users/username

pub opaque type Core {
  Core(username: username.Username, password: password.Password)
}

pub fn new(user_id: username.Username, password: password.Password) -> Core {
  Core(user_id, password)
}

pub fn get_username(core: Core) -> username.Username {
  core.username
}

pub fn get_password(core: Core) -> password.Password {
  core.password
}

pub fn to_primitives(core c: Core) -> List(#(String, String)) {
  [
    #("id", c.username |> username.value_of),
    #("password", c.password |> password.value_of),
  ]
}
