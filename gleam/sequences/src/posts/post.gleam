import posts/content
import posts/title
import users/users

pub opaque type Post {
  Post(author: users.User, title: title.Title, content: content.Content)
}

pub fn new(
  user: users.User,
  title: title.Title,
  content: content.Content,
) -> Post {
  Post(user, title, content)
}

pub fn save() -> Result(Nil, Nil) {
  Ok(Nil)
}
