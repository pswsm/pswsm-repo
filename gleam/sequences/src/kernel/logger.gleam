import gleam/json
import gleam/option
import gleam/string_builder
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
  happened at: timestamps.Timestamp,
) -> String {
  let message_builder =
    json.to_string_builder(
      json.object([
        #("severity", json.string(severity.value)),
        #("message", json.string(message)),
        #("timestamp", json.string(timestamps.to_string(at))),
      ]),
    )
  let message = message_builder |> string_builder.to_string
  logging.log(severity.level, message)
  message
}
