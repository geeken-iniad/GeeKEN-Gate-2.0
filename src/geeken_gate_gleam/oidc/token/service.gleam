import gleam/json
import gleam/uri

import glen
import glen/status

pub type TokenErrorResponse {
  TokenErrorResponse(error: TokenErrorCode)
}

/// See [RFC 6749 §5.2](https://www.rfc-editor.org/rfc/rfc6749.html#section-5.2).
pub type TokenErrorCode {
  InvalidRequest
  InvalidClient
  InvalidGrant
  UnauthorizedClient
  UnsupportedGrantType
  InvalidScope
}

/// See [RFC 6749 §5.2](https://www.rfc-editor.org/rfc/rfc6749.html#section-5.2).
pub fn error_code_to_string(code: TokenErrorCode) -> String {
  case code {
    InvalidRequest -> "invalid_request"
    InvalidClient -> "invalid_client"
    InvalidGrant -> "invalid_grant"
    UnauthorizedClient -> "unauthorized_client"
    UnsupportedGrantType -> "unsupported_grant_type"
    InvalidScope -> "invalid_scope"
  }
}

pub fn build_error_response_json(response: TokenErrorResponse) -> json.Json {
  json.object([
    #("error", response.error |> error_code_to_string |> json.string),
  ])
}

/// Respond with HTTP 400 (Bad Request) status code (unless specified otherwise)
/// See [RFC 6749 §5.2](https://www.rfc-editor.org/rfc/rfc6749.html#section-5.2).
pub fn new_error_response(error_code: TokenErrorCode) -> glen.Response {
  new_error_response_with(error_code, status.bad_request)
}

pub fn new_error_response_with(
  error_code: TokenErrorCode,
  http_status_code: Int,
) -> glen.Response {
  glen.json(
    TokenErrorResponse(error: error_code)
      |> build_error_response_json
      |> json.to_string,
    http_status_code,
  )
}

/// See [RFC 6749 §4.1.3](https://www.rfc-editor.org/rfc/rfc6749.html#section-4.1.3).
pub type TokenRequestDto {
  TokenRequestDto(
    // Header
    client_secret: String,
    // Body
    grant_type: GrantType,
    authorization_code: String,
    redirect_uri: uri.Uri,
    code_verifier: String,
  )
}

pub type GrantType {
  AuthorizationCode
}

/// See:
///   [Final: OpenID Connect Core 1.0 incorporating errata set 2 §3.1.3.3](https://openid.net/specs/openid-connect-core-1_0.html#rfc.section.3.1.3.3)
///   [RFC 6749 §4.1.4](https://www.rfc-editor.org/rfc/rfc6749.html#section-4.1.4)
///   [RFC 6749 §5.1](https://www.rfc-editor.org/rfc/rfc6749.html#section-5.1)
pub type SuccessfulTokenResponseDto {
  SuccessfulTokenResponseDto(
    access_token: String,
    token_type: TokenType,
    expires_in: Int,
    refresh_token: String,
    id_token: String,
    scope: String,
  )
}

pub type TokenType {
  Bearer
}
