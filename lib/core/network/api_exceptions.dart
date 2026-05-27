class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  const NetworkException([super.message = 'No internet connection']);
}

class TimeoutApiException extends ApiException {
  const TimeoutApiException([super.message = 'Request timed out']);
}

class ServerException extends ApiException {
  final int statusCode;
  final String responseBody;

  const ServerException({
    required this.statusCode,
    required this.responseBody,
    String message = 'Server error',
  }) : super(message);
}

class InvalidResponseException extends ApiException {
  const InvalidResponseException([super.message = 'Invalid response format']);
}
