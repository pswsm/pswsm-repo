import gleam/bool
import gleam/http
import gleam/list

pub type Route {
  Route(method: http.Method, path: List(String))
}

pub fn equals(this route: Route, equals that: Route) -> Bool {
  use <- bool.guard(route.method != that.method, False)

  use <- bool.guard(
    list.zip(route.path, that.path)
      |> list.all(fn(e) { e.0 == e.1 })
      |> bool.negate,
    False,
  )
  True
}
