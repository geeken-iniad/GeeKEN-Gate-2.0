import gleam/javascript/promise.{type Promise}

import glen
import glen/status

pub fn main() {
  glen.serve(8000, handle_req)
}

fn handle_req(req: glen.Request) -> Promise(glen.Response) {
  case glen.path_segments(req) {
    [""] ->
      "/"
      |> glen.json(status.ok)
      |> promise.resolve

    ["token"] ->
      "/token"
      |> glen.json(status.ok)
      |> promise.resolve

    _ ->
      "else"
      |> glen.json(status.not_found)
      |> promise.resolve
  }
}
