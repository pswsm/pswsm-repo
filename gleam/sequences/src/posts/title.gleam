pub opaque type Title {
  Title(String)
}

pub fn new(title title: String) -> Title {
  Title(title)
}

pub fn value_of(title title: Title) -> String {
  case title {
    Title(value) -> value
  }
}
