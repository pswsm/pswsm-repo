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

pub fn if_error(
  on r: Result(a, b),
  then do: fn(b) -> c,
  otherwise execute: fn(a) -> c,
) -> c {
  case r {
    Error(b) -> do(b)
    Ok(a) -> execute(a)
  }
}

/// If the given result it's an `Error`, returns it,
/// else runs callback function.
pub fn interrogant(
  on r: Result(a, b),
  then do: fn(a) -> Result(c, b),
) -> Result(c, b) {
  case r {
    Error(b) -> Error(b)
    Ok(a) -> do(a)
  }
}

pub fn is_empty(
  this list: List(a),
  then do: fn() -> c,
  otherwise execute: fn(List(a)) -> c,
) -> c {
  case list {
    [] -> do()
    [_, ..] -> execute(list)
  }
}

pub fn get_key(
  from d: dict.Dict(a, b),
  key k: a,
  parse with: fn(b) -> c,
) -> Result(c, String) {
  use value <- if_error(dict.get(d, k), fn(_err) {
    let d_key = dynamic.from(k)
    { "Key " <> { dynamic.string(d_key) |> result.unwrap("") } <> " not found" }
    |> Error
  })
  Ok(value |> with)
}

pub fn if_none(
  on o: option.Option(a),
  then do: fn() -> b,
  otherwise execute: fn(a) -> b,
) -> b {
  case o {
    option.None -> do()
    option.Some(a) -> execute(a)
  }
}
