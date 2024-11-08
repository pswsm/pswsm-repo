pub opaque type Content {
  Content(value: String)
}

pub fn new(content: String) -> Content {
  Content(content)
}

pub fn value_of(content: Content) -> String {
  content.value
}
