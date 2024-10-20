import auth/auth
import gleam/http/request
import gleam/http/response
import gleam/json
import gleam/list
import gleam/option
import http/http_errors as errors
import http/http_utils
import http/responses
import mist
import users/id
import users/user_errors
import users/user_finder
import users/users

pub fn handle_get_api(path: List(String), request: request.Request(_)) {
  case path {
    ["users"] -> find(request)
    ["users", id] -> get(id)
    ["auth", username] -> auth(username)
    _ -> errors.new_internal_server_error() |> errors.to_response
  }
}

fn find(request r: request.Request(_)) -> response.Response(mist.ResponseData) {
  use <- option.lazy_unwrap(http_utils.authorize(r))

  let users = user_finder.find_all()
  case users {
    Ok(users) -> {
      let users = users |> list.map(users.to_resource)

      responses.base_response()
      |> responses.with_json_body(users |> json.preprocessed_array)
      |> responses.to_mist
    }
    Error(e) ->
      errors.new_internal_server_error()
      |> errors.set_message(e |> user_errors.message)
      |> errors.to_response
  }
}

pub fn get(id id: String) {
  let user = user_finder.get(id |> id.from_string)

  case user {
    Ok(user) -> {
      responses.base_response()
      |> responses.with_json_body(user |> users.to_resource)
      |> responses.to_mist
    }
    Error(_) -> errors.new_not_found() |> errors.to_response
  }
}

pub fn auth(username u: String) {
  let auth = auth.auth(u)

  case auth {
    Ok(auth) -> {
      responses.base_response()
      |> responses.with_json_body(
        [#("token", auth |> json.string)] |> json.object,
      )
      |> responses.to_mist
    }
    Error(_) -> errors.new_not_found() |> errors.to_response
  }
}
