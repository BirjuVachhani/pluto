/// An exception thrown when a Pexels API request fails.
class PexelsException implements Exception {
  /// The HTTP status code of the response.
  final int statusCode;

  /// A human-readable error message.
  final String message;

  const PexelsException({required this.statusCode, required this.message});

  @override
  String toString() => 'PexelsException($statusCode): $message';
}
