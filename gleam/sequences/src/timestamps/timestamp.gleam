import gleam/erlang

/// A timestamp in milliseconds.
///
/// To create a new timestamp use `timestamp.new()`.
pub opaque type Timestamp {
  Timestamp(value: Int)
}

/// Returns the current time as a timestamp in milliseconds.
///
/// Example:
/// ```gleam
/// let ts = new()
/// // -> 1731431350344
/// ```
pub fn new() -> Timestamp {
  Timestamp(erlang.system_time(erlang.Millisecond))
}

/// Creates a timestamp from given milliseconds.
///
/// Example:
/// ```gleam
/// let ts = from_millis(1731431350344)
/// // -> 1731431350344
/// ```
pub fn from_millis(milliseconds millis: Int) -> Timestamp {
  Timestamp(millis)
}

/// Returns a timestamp that is `hours` hours after the given timestamp.
///
/// Example:
/// ```gleam
/// let ts = from_millis(1731431350344)
/// let ts_plus_2_hours = add_hours(ts, 2)
/// // -> 1731438550344
/// ```
pub fn add_hours(to_this timestamp: Timestamp, no_of hours: Int) -> Timestamp {
  Timestamp(timestamp.value + hours * 60 * 60 * 1000)
}

/// Checks if the first timestamp is before the second timestamp.
///
/// Example:
/// ```gleam
/// let ts1 = from_millis(1731431350344)
/// let ts2 = from_millis(1731431350345)
/// is_before(ts1, ts2) // -> True
/// ```
pub fn is_after(timestamp1 t1: Timestamp, timestamp2 t2: Timestamp) -> Bool {
  value_of(t1) > value_of(t2)
}

/// Checks if the given timestamp is in the future.
///
/// Example:
/// ```gleam
/// let ts = from_millis(2031431350344)
/// is_future(ts) // -> True
/// ```
pub fn is_future(timestamp t: Timestamp) -> Bool {
  t |> is_after(new())
}

/// Returns the value of the timestamp as an Int.
pub fn value_of(timestamp t: Timestamp) -> Int {
  t.value
}
