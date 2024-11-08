import gleam/erlang/os
import gleam/int
import http/server
import logging
import utils

pub fn start_logs() {
  logging.configure()
  logging.set_level(level_from_env())
}

pub fn start_server() {
  let port = get_port()
  server.run(port)
}

fn level_from_env() -> logging.LogLevel {
  case os.get_env("LOG_LEVEL") {
    Error(_) -> logging.Info
    Ok(level) -> level_from_string(level)
  }
}

fn level_from_string(level: String) -> logging.LogLevel {
  case level {
    "debug" -> logging.Debug
    "warn" -> logging.Warning
    "error" -> logging.Error
    _ -> logging.Info
  }
}

fn get_port() -> Int {
  use unparsed_port <- utils.if_error(os.get_env("PORT"), fn(_) { 8080 })
  let assert Ok(port) = int.parse(unparsed_port)
  port
}
