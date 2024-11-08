import gleam/json
import gleam/string_builder
import logging

pub opaque type Severity {
  Debug(value: String, level: logging.LogLevel)
  Info(value: String, level: logging.LogLevel)
  Warning(value: String, level: logging.LogLevel)
  Error(value: String, level: logging.LogLevel)
}

pub fn debug(message to_log: String) -> String {
  Debug("debug", logging.Debug) |> log(to_log)
}

pub fn info(message to_log: String) -> String {
  Info("info", logging.Info) |> log(to_log)
}

pub fn warning(message to_log: String) -> String {
  Warning("warning", logging.Warning) |> log(to_log)
}

pub fn error(message to_log: String) -> String {
  Error("error", logging.Error) |> log(to_log)
}

fn log(with severity: Severity, log message: String) -> String {
  let message_builder =
    json.to_string_builder(
      json.object([
        #("severity", json.string(severity.value)),
        #("message", json.string(message)),
      ]),
    )
  let message = message_builder |> string_builder.to_string
  logging.log(severity.level, message)
  message
}
