import gleam/dynamic
import gleam/json
import posts/post

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
    dynamic.field("date", dynamic.int),
  )
}
