enum APIError {
  serverError,
}

class VeryfiException implements Exception {
  final APIError errorType;
  final int statusCode;
  final String response;
  VeryfiException(this.errorType, this.statusCode, this.response);
}
