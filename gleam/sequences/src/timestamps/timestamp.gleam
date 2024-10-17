import gleam/erlang
import gleam/int

pub opaque type Timestamp {
  Timestamp(Int)
}

pub fn new() -> Timestamp {
  Timestamp(erlang.system_time(erlang.Millisecond))
}

pub fn from_millis(milliseconds millis: Int) -> Timestamp {
  Timestamp(millis)
}

pub fn to_sting(timestamp: Timestamp) -> String {
  case timestamp {
    Timestamp(millis) -> int.to_string(millis)
  }
}

pub fn add_hours(timestamp: Timestamp, hours: Int) -> Timestamp {
  case timestamp {
    Timestamp(millis) -> Timestamp(millis + hours * 60 * 60 * 1000)
  }
}
