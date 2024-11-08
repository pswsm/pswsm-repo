import gleam/json
import gleam/string_builder
import logging

pub opaque type Severity {
  Debug(value: String, level: logging.LogLevel)
  Info(value: String, level: logging.LogLevel)
  Warning(value: String, level: logging.LogLevel)
  Error(value: String, level: logging.LogLevel)
}

pub fn debug() -> Severity {
  Debug("debug", logging.Debug)
}

pub fn info() -> Severity {
  Info("info", logging.Info)
}

pub fn warning() -> Severity {
  Warning("warning", logging.Warning)
}

pub fn error() -> Severity {
  Error("error", logging.Error)
}

pub fn log(with severity: Severity, log message: String) -> Nil {
  let message_builder =
    json.to_string_builder(
      json.object([
        #("severity", json.string(severity.value)),
        #("message", json.string(message)),
      ]),
    )
  logging.log(severity.level, message_builder |> string_builder.to_string)
}
