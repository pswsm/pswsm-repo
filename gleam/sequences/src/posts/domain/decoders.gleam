import gleam/dynamic
import gleam/json
import gleam/list
import posts/domain/post

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

pub fn to_couchdb(post: post.Post) -> json.Json {
  post
  |> post.to_primitives
  |> list.map(fn(t) {
    case t.0 == "id" {
      True -> #("_id", t.1)
      False -> #(t.0, t.1)
    }
  })
  |> json.object
}
