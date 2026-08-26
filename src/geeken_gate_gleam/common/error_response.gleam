import gleam/json
import gleam/option.{type Option}
import gleam/uri.{type Uri}

/// See [RFC 6749 §5.2](https://www.rfc-editor.org/rfc/rfc6749.html#section-5.2).
pub type ErrorResponse {
  ErrorResponse(
    error: String,
    error_description: Option(String),
    error_uri: Option(Uri),
  )
}

pub fn to_json(error_response: ErrorResponse) {
  let optional_fields =
    [
      error_response.error_description
        |> option.map(fn(description: String) {
          #("error_description", json.string(description))
        }),
      error_response.error_uri
        |> option.map(fn(uri: Uri) {
          #("error_uri", json.string(uri |> uri.to_string))
        }),
    ]
    |> option.values

  json.object([#("error", json.string(error_response.error)), ..optional_fields])
}
