import gleam/dynamic
import gleam/int
import gleam/json
import users/users
import utils

pub fn map(map_this docs: String) -> Result(List(users.User), json.DecodeError) {
  json.decode(
    docs,
    dynamic.field(
      "docs",
      dynamic.list(dynamic.decode4(
        users.from_primitves,
        dynamic.field("_id", dynamic.string),
        dynamic.field("username", dynamic.string),
        dynamic.field("password", dynamic.string),
        dynamic.field(
          "created_at",
          dynamic.any([
            fn(ct) {
              use string_ct <- utils.if_error(ct |> dynamic.string, Error(_))

              use int_ct <- utils.if_error(
                string_ct
                  |> int.parse,
                fn(_) {
                  [
                    dynamic.DecodeError(expected: "Int", found: "String", path: [
                      "created_at",
                    ]),
                  ]
                  |> Error
                },
              )
              int_ct |> Ok
            },
          ]),
        ),
      )),
    ),
  )
}
