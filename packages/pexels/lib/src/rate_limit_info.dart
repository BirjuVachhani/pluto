/// Rate limit information from Pexels API response headers.
class RateLimitInfo {
  /// The maximum number of requests allowed per month.
  final int limit;

  /// The number of requests remaining in the current month.
  final int remaining;

  /// The time at which the rate limit resets.
  final DateTime resetAt;

  const RateLimitInfo({
    required this.limit,
    required this.remaining,
    required this.resetAt,
  });

  /// Whether the rate limit has been exceeded.
  bool get isExceeded => remaining <= 0;

  /// Parses rate limit info from Pexels API response headers.
  ///
  /// Returns `null` if the headers are not present.
  static RateLimitInfo? fromHeaders(Map<String, String> headers) {
    final limit = int.tryParse(headers['x-ratelimit-limit'] ?? '');
    final remaining = int.tryParse(headers['x-ratelimit-remaining'] ?? '');
    final resetEpoch = int.tryParse(headers['x-ratelimit-reset'] ?? '');

    if (limit == null || remaining == null || resetEpoch == null) return null;

    return RateLimitInfo(
      limit: limit,
      remaining: remaining,
      resetAt: DateTime.fromMillisecondsSinceEpoch(resetEpoch * 1000),
    );
  }

  @override
  String toString() =>
      'RateLimitInfo(limit: $limit, remaining: $remaining, resetAt: $resetAt)';
}
