pub opaque type Username {
  Username(String)
}

pub fn new(username: String) -> Username {
  Username(username)
}

pub fn value_of(username: Username) -> String {
  case username {
    Username(value) -> value
  }
}
