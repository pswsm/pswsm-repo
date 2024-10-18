import gleam/erlang

pub opaque type Timestamp {
  Timestamp(Int)
}

/// Returns the current time as a timestamp in milliseconds.
pub fn new() -> Timestamp {
  Timestamp(erlang.system_time(erlang.Millisecond))
}

/// Created a timestamp from milliseconds.
pub fn from_millis(milliseconds millis: Int) -> Timestamp {
  Timestamp(millis)
}

/// Returns a timestmamp + N hours
pub fn add_hours(timestamp: Timestamp, hours: Int) -> Timestamp {
  case timestamp {
    Timestamp(millis) -> Timestamp(millis + hours * 60 * 60 * 1000)
  }
}

pub fn is_after(timetamp1 t1: Timestamp, timestamp2 t2: Timestamp) -> Bool {
  value_of(t1) > value_of(t2)
}

pub fn is_future(timestamp t: Timestamp) -> Bool {
  t |> is_after(new())
}

pub fn value_of(timestamp t: Timestamp) -> Int {
  case t {
    Timestamp(millis) -> millis
  }
}
