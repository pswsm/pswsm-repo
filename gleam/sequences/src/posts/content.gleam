pub opaque type Content {
  Content(String)
}

pub fn new(content: String) -> Content {
  Content(content)
}

pub fn value_of(content: Content) -> String {
  case content {
    Content(value) -> value
  }
}
