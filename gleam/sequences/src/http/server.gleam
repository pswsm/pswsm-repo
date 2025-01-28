import gleam/erlang/process
import gleam/http
import gleam/http/request
import gleam/http/response
import gleam/io
import gleam/json
import gleam/list
import gleam/option
import gleam/string
import http/http_errors
import http/responses
import http/route
import kernel/logger
import mist
import utils

pub type Controller {
  Controller(
    route: route.Route,
    handler: fn(request.Request(mist.Connection)) ->
      response.Response(mist.ResponseData),
  )
}

pub fn run(port: Int, controllers: List(Controller)) {
  let _selector = process.new_selector()
  let _state = Nil

  let health_controllers =
    controllers
    |> list.map(fn(controller) {
      http.method_to_string(controller.route.method) |> string.uppercase
      <> " "
      <> utils.implode(controller.route.path, option.Some("/"))
    })
    |> list.map(logger.info)

  let assert Ok(_) =
    fn(req: request.Request(mist.Connection)) -> response.Response(
      mist.ResponseData,
    ) {
      case request.path_segments(req) {
        ["health", ..] ->
          responses.ok()
          |> responses.with_json_body(
            health_controllers |> json.array(json.string),
          )
          |> responses.to_mist
        _ ->
          handle(req.method, request.path_segments(req), req, controllers)
          |> response.set_header("access-control-allow-origin", "*")
      }
    }
    |> mist.new
    |> mist.port(port)
    |> mist.start_http

  process.sleep_forever()
}

fn handle(
  method m: http.Method,
  path p: List(String),
  request r: request.Request(mist.Connection),
  loaded controllers: List(Controller),
) -> response.Response(mist.ResponseData) {
  let current_route = route.Route(m, p)

  use controller <- utils.if_error(
    controllers
      |> list.find(fn(controller) {
        controller.route
        |> route.equals(current_route)
      }),
    fn(_) {
      http_errors.not_found(option.Some(
        "route "
        <> utils.implode(current_route.path, option.Some("/"))
        <> " not found",
      ))
      |> http_errors.to_response
    },
  )
  io.debug(controller)
  controller.handler(r)
}
