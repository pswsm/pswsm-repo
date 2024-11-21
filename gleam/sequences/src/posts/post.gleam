import gleam/json
import infra/infraestructura
import posts/content
import posts/errors
import posts/title
import timestamps
import users/id
import utils

pub opaque type Post {
  Post(
    id: String,
    author: id.UserId,
    title: title.Title,
    content: content.Content,
    date: timestamps.Timestamp,
  )
}

pub fn new(
  post_id id: String,
  author user: id.UserId,
  title title: title.Title,
  body content: content.Content,
) -> Post {
  Post(id, user, title, content, timestamps.new())
}

pub fn save(this post: Post) -> Result(Nil, errors.PostError) {
  use db <- infraestructura.get_default("posts")
  use _db_object <- utils.if_error(
    infraestructura.persist(db, to_primitives(post) |> json.object),
    fn(infra_msg) { errors.post_error(infra_msg) |> Error },
  )
  Ok(Nil)
}

pub fn to_primitives(post: Post) -> List(#(String, json.Json)) {
  [
    #("id", post.id |> json.string),
    #("author", id.to_json(post.author)),
    #("title", title.value_of(post.title) |> json.string),
    #("content", content.value_of(post.content) |> json.string),
    #("date", timestamps.to_string(post.date) |> json.string),
  ]
}

pub fn from_primitives(
  id: String,
  user: String,
  title: String,
  content: String,
  date: Int,
) -> Post {
  Post(
    id,
    user |> id.from_string,
    title |> title.new,
    content |> content.new,
    date |> timestamps.from_millis,
  )
}
