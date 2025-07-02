class ServerException implements Exception {
  final String message;
  const ServerException({this.message = 'Server Exception'});

  @override
  String toString() => 'ServerException: $message';
}

// You might also have other custom exceptions here, for example:
class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'Cache Exception'});

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'Network Error'});

  @override
  String toString() => 'NetworkException: $message';
}