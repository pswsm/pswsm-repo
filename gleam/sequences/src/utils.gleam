import gleam/dict
import gleam/dynamic
import gleam/list
import gleam/option
import gleam/result
import gleam/string_builder

pub fn remove_first(llista: List(t)) -> List(t) {
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

pub fn if_error(r: Result(a, b), then: fn(b) -> c, otherwise: fn(a) -> c) -> c {
  case r {
    Error(b) -> then(b)
    Ok(a) -> otherwise(a)
  }
}

pub fn key_exists(d: dict.Dict(a, b), k: a) -> Result(dict.Dict(a, b), String) {
  case dict.get(d, k) {
    Ok(_) -> Ok(d)
    Error(_) ->
      Error(
        "Key"
        <> { dynamic.string(dynamic.from(k)) |> result.unwrap("") }
        <> "not found",
      )
  }
}
