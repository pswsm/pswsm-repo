import gleam/dynamic
import gleam/int
import gleam/json
import posts/post
import utils

pub fn to_domain(doc: String) -> Result(post.Post, json.DecodeError) {
  json.decode(doc, post(False))
}

pub fn post(
  body: Bool,
) -> fn(dynamic.Dynamic) -> Result(post.Post, dynamic.DecodeErrors) {
  dynamic.decode5(
    post.from_primitives,
    dynamic.field(
      {
        case body {
          True -> "id"
          False -> "_id"
        }
      },
      dynamic.string,
    ),
    dynamic.field("author", dynamic.string),
    dynamic.field("title", dynamic.string),
    dynamic.field("content", dynamic.string),
    dynamic.field(
      "date",
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
  )
}
