import dotenv_gleam
import kernel/kernel

pub fn main() {
  dotenv_gleam.config()
  kernel.start_logs()
  kernel.start_server()
}
