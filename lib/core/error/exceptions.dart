class ServerException implements Exception {
  final String message;
  const ServerException({this.message = 'A server error occurred.'});
}

class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'A local data error occurred.'});
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'No internet connection.'});
}
