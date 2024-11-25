pub opaque type Title {
  Title(value: String)
}

pub fn new(title title: String) -> Title {
  Title(value: title)
}

pub fn value_of(title title: Title) -> String {
  title.value
}
