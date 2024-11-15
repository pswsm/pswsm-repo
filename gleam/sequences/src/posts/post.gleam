import gleam/json
import posts/content
import posts/title
import users/users

pub opaque type Post {
  Post(author: users.User, title: title.Title, content: content.Content)
}

pub fn new(
  author user: users.User,
  title title: title.Title,
  body content: content.Content,
) -> Post {
  Post(user, title, content)
}

pub fn save() -> Result(Nil, Nil) {
  Ok(Nil)
}

pub fn to_primitives(post: Post) -> List(#(String, json.Json)) {
  [
    #("author", users.to_primitives(post.author) |> json.object),
    #("title", title.value_of(post.title) |> json.string),
    #("content", content.value_of(post.content) |> json.string),
  ]
}
