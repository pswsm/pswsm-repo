import gleam/json
import passwords/password
import users/id

pub opaque type Criticals {
  Criticals(id.UserId, password.Password)
}

pub fn new(user_id: id.UserId, password: password.Password) -> Criticals {
  Criticals(user_id, password)
}

pub fn id(c: Criticals) -> id.UserId {
  case c {
    Criticals(id, _) -> id
  }
}

pub fn password(c: Criticals) -> password.Password {
  case c {
    Criticals(_, password) -> password
  }
}

pub fn to_json(c: Criticals) -> json.Json {
  json.object([
    #("id", c |> id |> id.to_json),
    #("password", c |> password |> password.to_json),
  ])
}
