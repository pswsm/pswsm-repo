import gleam/bit_array
import gleam/result

/// A user identifier
pub opaque type UserId {
  /// The user identifier as a bit array
  UserId(BitArray)
}

/// Create a new user identifier from a string
pub fn from_string(raw_id: String) -> UserId {
  UserId(raw_id |> bit_array.from_string)
}

/// Create a new user identifier from a bit array
pub fn from_bit_array(raw_id: BitArray) -> UserId {
  UserId(raw_id)
}

/// Get the value of a user identifier as a string
pub fn as_string(id: UserId) -> String {
  case id {
    UserId(id) -> id |> bit_array.to_string |> result.unwrap("-1")
  }
}

/// Get the value of a user identifier
pub fn as_bit_array(id: UserId) -> BitArray {
  case id {
    UserId(id) -> id
  }
}
