import gleam/http/response
import gleam/json
import gleam/list
import http/http_errors as errors
import http/responses
import mist
import users/id
import users/user_errors
import users/users

pub fn handle_get_api(path: List(String)) {
  case path {
    ["users"] -> find()
    ["users", id] -> get(id)
    _ -> errors.new_internal_server_error() |> errors.to_response
  }
}

fn find() -> response.Response(mist.ResponseData) {
  let users = users.find_all()

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
  let user = users.get(id |> id.from_string)

  case user {
    Ok(user) -> {
      responses.base_response()
      |> responses.with_json_body(user |> users.to_resource)
      |> responses.to_mist
    }
    Error(_) -> errors.new_not_found() |> errors.to_response
  }
}
