import gleam/option
import logging
import timestamps

pub opaque type Severity {
  Debug(value: String, level: logging.LogLevel)
  Info(value: String, level: logging.LogLevel)
  Warning(value: String, level: logging.LogLevel)
  Error(value: String, level: logging.LogLevel)
}

pub fn debug(message to_log: String) -> String {
  Debug("debug", logging.Debug) |> log(to_log, timestamps.new())
}

pub fn info(message to_log: String) -> String {
  Info("info", logging.Info) |> log(to_log, timestamps.new())
}

pub fn warning(message to_log: String) -> String {
  Warning("warning", logging.Warning) |> log(to_log, timestamps.new())
}

pub fn error(
  message to_log: String,
  time timestamp: option.Option(timestamps.Timestamp),
) -> String {
  let time = option.unwrap(timestamp, timestamps.new())
  Error("error", logging.Error) |> log(to_log, time)
}

fn log(
  with severity: Severity,
  log message: String,
  happened _at: timestamps.Timestamp,
) -> String {
  logging.log(severity.level, message)
  message
}
