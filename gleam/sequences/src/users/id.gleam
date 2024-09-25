import gleam/bit_array
import gleam/result

pub opaque type UserId {
  UserId(BitArray)
}

pub fn from_string(raw_id: String) -> UserId {
  UserId(raw_id |> bit_array.from_string)
}

pub fn from_bit_array(raw_id: BitArray) -> UserId {
  UserId(raw_id)
}

pub fn as_string(id: UserId) -> String {
  case id {
    UserId(id) -> id |> bit_array.to_string |> result.unwrap("-1")
  }
}

pub fn as_bit_array(id: UserId) -> BitArray {
  case id {
    UserId(id) -> id
  }
}
