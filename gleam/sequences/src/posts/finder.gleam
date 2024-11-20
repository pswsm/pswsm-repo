import gleam/result
import infra/infraestructura
import posts/decoders
import posts/errors
import posts/post
import utils

pub fn get(by id: String) -> Result(post.Post, errors.PostError) {
  use db <- infraestructura.get_default("posts")

  use maybe_post <- utils.if_error(
    {
      infraestructura.get_by_id(db, id, decoders.to_domain)
      |> result.map_error(errors.post_error)
    },
    Error(_),
  )

  maybe_post
  |> result.map_error(fn(_) { errors.post_error("post " <> id <> " not found") })
}
