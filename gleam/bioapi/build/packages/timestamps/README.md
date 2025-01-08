# timestamps

[![Package Version](https://img.shields.io/hexpm/v/timestamps)](https://hex.pm/packages/timestamps)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/timestamps/)

```sh
gleam add timestamps@1
```
```gleam
import timestamps

pub fn main() {
  let now = timestamps.now()
  io.println("The current time is: " <> now |> timestamps.to_string)
}
```

Further documentation can be found at <https://hexdocs.pm/timestamps>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
