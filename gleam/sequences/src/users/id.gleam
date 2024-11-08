import gleam/bit_array
import gleam/json

pub opaque type UserId {
  UserId(value: String)
}

pub fn from_string(raw_id: String) -> UserId {
  UserId(raw_id)
}

@deprecated("Use `value_of` instead")
pub fn as_string(id: UserId) -> String {
  case id {
    UserId(id) -> id
  }
}

pub fn as_bit_array(id: UserId) -> BitArray {
  id.value |> bit_array.from_string
}

pub fn to_json(id: UserId) -> json.Json {
  value_of(id) |> json.string
}

pub fn value_of(id: UserId) -> String {
  id.value
}
