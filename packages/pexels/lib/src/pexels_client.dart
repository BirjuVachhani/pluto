import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import 'models/collection.dart';
import 'models/media.dart';
import 'models/photo.dart';
import 'models/video.dart';
import 'pexels_exception.dart';

/// A client for interacting with the Pexels API.
///
/// Provides methods to search and retrieve photos, videos, and collections.
///
/// ```dart
/// final client = PexelsClient(apiKey: 'YOUR_API_KEY');
///
/// final photos = await client.searchPhotos(query: 'nature');
/// for (final photo in photos.photos) {
///   print(photo.src.medium);
/// }
///
/// client.close();
/// ```
class PexelsClient {
  static const String _photoBaseUrl = 'https://api.pexels.com/v1';
  static const String _videoBaseUrl = 'https://api.pexels.com/videos';
  static const String _collectionBaseUrl =
      'https://api.pexels.com/v1/collections';

  /// The API key used for authentication.
  final String apiKey;

  final http.Client _client;
  final bool _ownsClient;

  /// Creates a new [PexelsClient] with the given [apiKey].
  ///
  /// Optionally accepts a custom [http.Client] for making requests.
  /// This is useful for testing or when using an intercepted client
  /// (e.g., from `package:http_interceptor`).
  ///
  /// If no [client] is provided, a default [http.Client] is created
  /// and will be closed when [close] is called.
  PexelsClient({required this.apiKey, http.Client? client})
      : _client = client ?? http.Client(),
        _ownsClient = client == null;

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'User-Agent': 'Pexels/Dart',
        'Authorization': apiKey,
      };

  // ---------------------------------------------------------------------------
  // Photos
  // ---------------------------------------------------------------------------

  /// Searches for photos matching the given [query].
  ///
  /// Returns a [PhotoList] containing the matching photos with pagination info.
  ///
  /// Optional parameters:
  /// - [page]: The page number to return (default: 1).
  /// - [perPage]: The number of results per page (default: 15, max: 80).
  /// - [orientation]: Filter by orientation: `landscape`, `portrait`, or `square`.
  /// - [size]: Filter by minimum size: `large` (24MP), `medium` (12MP), or `small` (4MP).
  /// - [color]: Filter by color. Hex color code (without #) or a named color.
  /// - [locale]: The locale for the search query (e.g., `en-US`, `pt`, `es`).
  Future<PhotoList> searchPhotos({
    required String query,
    int? page,
    int? perPage,
    String? orientation,
    String? size,
    String? color,
    String? locale,
  }) async {
    final json = await _get(_photoBaseUrl, '/search', _params({
      'query': query,
      'page': page,
      'per_page': perPage,
      'orientation': orientation,
      'size': size,
      'color': color,
      'locale': locale,
    }));
    return PhotoList.fromJson(json);
  }

  /// Retrieves a curated list of photos selected by the Pexels team.
  ///
  /// Optional parameters:
  /// - [page]: The page number to return (default: 1).
  /// - [perPage]: The number of results per page (default: 15, max: 80).
  Future<PhotoList> getCuratedPhotos({int? page, int? perPage}) async {
    final json = await _get(_photoBaseUrl, '/curated', _params({
      'page': page,
      'per_page': perPage,
    }));
    return PhotoList.fromJson(json);
  }

  /// Retrieves a single photo by its [id].
  Future<Photo> getPhoto({required int id}) async {
    final json = await _get(_photoBaseUrl, '/photos/$id', {});
    return Photo.fromJson(json);
  }

  /// Retrieves a random curated photo.
  ///
  /// Internally fetches a random page from the curated photos endpoint.
  /// Throws a [StateError] if no photos are available.
  Future<Photo> getRandomPhoto() async {
    final randomPage = Random().nextInt(1000) + 1;
    final result = await getCuratedPhotos(page: randomPage, perPage: 1);
    if (result.photos.isEmpty) {
      throw StateError('No curated photos found on random page $randomPage');
    }
    return result.photos.first;
  }

  // ---------------------------------------------------------------------------
  // Videos
  // ---------------------------------------------------------------------------

  /// Searches for videos matching the given [query].
  ///
  /// Returns a [VideoList] containing the matching videos with pagination info.
  ///
  /// Optional parameters:
  /// - [page]: The page number to return (default: 1).
  /// - [perPage]: The number of results per page (default: 15, max: 80).
  /// - [orientation]: Filter by orientation: `landscape`, `portrait`, or `square`.
  /// - [size]: Filter by minimum size: `large`, `medium`, or `small`.
  /// - [locale]: The locale for the search query.
  /// - [minWidth]: Minimum width in pixels.
  /// - [maxWidth]: Maximum width in pixels.
  /// - [minDuration]: Minimum duration in seconds.
  /// - [maxDuration]: Maximum duration in seconds.
  Future<VideoList> searchVideos({
    required String query,
    int? page,
    int? perPage,
    String? orientation,
    String? size,
    String? locale,
    int? minWidth,
    int? maxWidth,
    int? minDuration,
    int? maxDuration,
  }) async {
    final json = await _get(_videoBaseUrl, '/search', _params({
      'query': query,
      'page': page,
      'per_page': perPage,
      'orientation': orientation,
      'size': size,
      'locale': locale,
      'min_width': minWidth,
      'max_width': maxWidth,
      'min_duration': minDuration,
      'max_duration': maxDuration,
    }));
    return VideoList.fromJson(json);
  }

  /// Retrieves a list of popular videos.
  ///
  /// Optional parameters:
  /// - [page]: The page number to return (default: 1).
  /// - [perPage]: The number of results per page (default: 15, max: 80).
  /// - [minWidth]: Minimum width in pixels.
  /// - [maxWidth]: Maximum width in pixels.
  /// - [minDuration]: Minimum duration in seconds.
  /// - [maxDuration]: Maximum duration in seconds.
  Future<VideoList> getPopularVideos({
    int? page,
    int? perPage,
    int? minWidth,
    int? maxWidth,
    int? minDuration,
    int? maxDuration,
  }) async {
    final json = await _get(_videoBaseUrl, '/popular', _params({
      'page': page,
      'per_page': perPage,
      'min_width': minWidth,
      'max_width': maxWidth,
      'min_duration': minDuration,
      'max_duration': maxDuration,
    }));
    return VideoList.fromJson(json);
  }

  /// Retrieves a single video by its [id].
  Future<Video> getVideo({required int id}) async {
    final json = await _get(_videoBaseUrl, '/videos/$id', {});
    return Video.fromJson(json);
  }

  // ---------------------------------------------------------------------------
  // Collections
  // ---------------------------------------------------------------------------

  /// Retrieves all collections belonging to the API key owner.
  ///
  /// Optional parameters:
  /// - [page]: The page number to return (default: 1).
  /// - [perPage]: The number of results per page (default: 15, max: 80).
  Future<CollectionList> getAllCollections({int? page, int? perPage}) async {
    final json = await _get(_collectionBaseUrl, '', _params({
      'page': page,
      'per_page': perPage,
    }));
    return CollectionList.fromJson(json);
  }

  /// Retrieves the media items in a collection by its [id].
  ///
  /// Optional parameters:
  /// - [page]: The page number to return (default: 1).
  /// - [perPage]: The number of results per page (default: 15, max: 80).
  /// - [type]: Filter by media type: `photos` or `videos`.
  Future<CollectionMediaList> getCollectionMedia({
    required String id,
    int? page,
    int? perPage,
    String? type,
  }) async {
    final json = await _get(_collectionBaseUrl, '/$id', _params({
      'page': page,
      'per_page': perPage,
      'type': type,
    }));
    return CollectionMediaList.fromJson(json);
  }

  /// Retrieves a list of featured collections curated by the Pexels team.
  ///
  /// Optional parameters:
  /// - [page]: The page number to return (default: 1).
  /// - [perPage]: The number of results per page (default: 15, max: 80).
  Future<CollectionList> getFeaturedCollections({
    int? page,
    int? perPage,
  }) async {
    final json = await _get(_collectionBaseUrl, '/featured', _params({
      'page': page,
      'per_page': perPage,
    }));
    return CollectionList.fromJson(json);
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  /// Converts a map with nullable values to a query parameter map,
  /// filtering out null values and converting all values to strings.
  static Map<String, String> _params(Map<String, Object?> raw) {
    return {
      for (final entry in raw.entries)
        if (entry.value != null) entry.key: entry.value.toString(),
    };
  }

  Future<Map<String, dynamic>> _get(
    String baseUrl,
    String path,
    Map<String, String> params,
  ) async {
    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: params.isNotEmpty ? params : null,
    );
    final response = await _client.get(uri, headers: _headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message = response.reasonPhrase ?? 'Unknown error';
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body.containsKey('error')) {
          message = body['error'] as String;
        }
      } catch (_) {
        // Use the reason phrase if we can't parse the body.
      }
      throw PexelsException(
        statusCode: response.statusCode,
        message: message,
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Closes the underlying HTTP client.
  ///
  /// If a custom [http.Client] was provided in the constructor, it will
  /// **not** be closed. Only the internally created client is closed.
  void close() {
    if (_ownsClient) {
      _client.close();
    }
  }
}
