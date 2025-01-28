import gleam/http/request
import gleam/http/response
import http/route
import mist

pub type Controller {
  Controller(
    route: route.Route,
    handler: fn(request.Request(mist.Connection)) ->
      response.Response(mist.ResponseData),
  )
}
