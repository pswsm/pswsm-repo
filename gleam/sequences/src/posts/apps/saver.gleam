import infra/infraestructura
import posts/domain/decoders as post_decoders
import posts/domain/errors
import posts/domain/post
import utils

pub fn save(this post: post.Post) -> Result(Nil, errors.PostError) {
  use db <- infraestructura.get_default("posts")
  use _db_object <- utils.if_error(
    infraestructura.persist(db, post_decoders.to_couchdb(post)),
    fn(infra_msg) { errors.post_error(infra_msg) |> Error },
  )
  Ok(Nil)
}
