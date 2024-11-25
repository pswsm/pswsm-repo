import kernel/domain_error

pub opaque type PostError {
  PostError(error: domain_error.DomainError)
}

pub fn post_error(msg: String) -> PostError {
  PostError(error: domain_error.throw(msg))
}

pub fn log(e: PostError) -> String {
  domain_error.log(e.error)
}
