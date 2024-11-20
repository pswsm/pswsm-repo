import gleam/option
import kernel/logger
import timestamps

pub opaque type DomainError {
  DomainError(message: String, timestamp: timestamps.Timestamp)
}

pub fn throw(message: String) -> DomainError {
  DomainError(message, timestamps.new())
}

pub fn log(e: DomainError) {
  logger.error(e.message, option.Some(e.timestamp))
}
