class APIException implements Exception {
  final String message;
  APIException(this.message);

  @override
  String toString() => 'APIException: $message';
}

class SpiderServiceException implements Exception {
  final String message;
  SpiderServiceException(this.message);

  @override
  String toString() => 'SpiderServiceException: $message';
}