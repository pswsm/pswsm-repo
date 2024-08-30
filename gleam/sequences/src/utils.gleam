import gleam/list
import gleam/option
import gleam/string_builder

pub fn remove_first(llista: List(_)) -> List(_) {
  llista
  |> list.drop(1)
}

pub fn implode(llista: List(String), with: option.Option(String)) -> String {
  llista
  |> list.map(string_builder.from_string)
  |> string_builder.join(option.unwrap(with, ""))
  |> string_builder.to_string()
}

pub fn extract_last_tuple3(tuple tuple: #(x, y, z)) -> z {
  let #(_, _, last) = tuple
  last
}
