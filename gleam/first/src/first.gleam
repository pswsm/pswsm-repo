import gleam/io
import gleam/string as text

pub fn main() {
  io.println("Hello from first!")
  io.println(text.reverse("olleH"))
}
