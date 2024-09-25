import gleam/bytes_builder
import gleam/dict
import gleam/http/request
import gleam/http/response
import gleam/json
import gleam/option
import gleam/result
import http/api/post_users
import http/errors
import infrastructure/sql
import mist
import sqlight
import users/users
import utils

pub fn handle_post_api(
  req: request.Request(mist.Connection),
  base_response: response.Response(mist.ResponseData),
) {
  let path_segments = request.path_segments(req)

  let req =
    req
    |> request.set_path(
      utils.remove_first(path_segments) |> utils.implode(option.Some("/")),
    )
  case request.path_segments(req) {
    ["users"] -> handle_post_user(req, base_response)
    _ -> base_response
  }
}

fn handle_post_user(
  req: request.Request(mist.Connection),
  res: response.Response(mist.ResponseData),
) {
  mist.read_body(req, 1024 * 1024 * 10)
  |> result.map_error(fn(_) { errors.new_bad_request() })
  |> result.try(post_users.decode_body)
  |> post_users.validate("id")
  |> post_users.validate("password")
  |> post_users.validate("username")
  |> result.try(fn(user) {
    users.new(
      id: dict.get(user, "id") |> result.unwrap("default"),
      password: dict.get(user, "password") |> result.unwrap("default"),
      username: dict.get(user, "username") |> result.unwrap("default"),
    )
    |> users.save(option.Some(sql.localdb))
    |> fn(res) {
      case res {
        Ok(user) -> Ok(user)
        Error(thing) -> {
          let msg = case thing {
            sqlight.SqlightError(_, message, _) -> message
          }
          errors.new_internal_server_error()
          |> errors.set_message(msg)
          |> Error
        }
      }
    }
  })
  |> result.map(fn(_) {
    res
    |> response.set_body(mist.Bytes(
      bytes_builder.new()
      |> bytes_builder.append_string(
        json.object([#("message", json.string("User created"))])
        |> json.to_string,
      ),
    ))
  })
  |> result.map_error(fn(error) { error |> errors.to_response })
  |> result.unwrap_both
}
