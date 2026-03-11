import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_testing;
import 'package:pexels/pexels.dart';
import 'package:test/test.dart';

void main() {
  late PexelsClient client;

  setUp(() {
    client = PexelsClient(
      apiKey: 'test-api-key',
      client: http_testing.MockClient((request) async {
        expect(request.headers['Authorization'], equals('test-api-key'));

        final path = request.url.path;

        if (path == '/v1/search') {
          return http.Response(
            jsonEncode(_photoSearchResponse),
            200,
          );
        }

        if (path == '/v1/curated') {
          return http.Response(jsonEncode(_curatedResponse), 200);
        }

        if (path.startsWith('/v1/photos/')) {
          return http.Response(jsonEncode(_singlePhoto), 200);
        }

        if (path == '/videos/search') {
          return http.Response(jsonEncode(_videoSearchResponse), 200);
        }

        if (path == '/videos/popular') {
          return http.Response(jsonEncode(_videoPopularResponse), 200);
        }

        if (path.startsWith('/videos/videos/')) {
          return http.Response(jsonEncode(_singleVideo), 200);
        }

        if (path == '/v1/collections') {
          return http.Response(jsonEncode(_collectionsResponse), 200);
        }

        if (path == '/v1/collections/featured') {
          return http.Response(jsonEncode(_featuredCollectionsResponse), 200);
        }

        if (path.startsWith('/v1/collections/')) {
          return http.Response(jsonEncode(_collectionMediaResponse), 200);
        }

        return http.Response(jsonEncode({'error': 'Not found'}), 404);
      }),
    );
  });

  group('Photos', () {
    test('searchPhotos returns PhotoList with total results', () async {
      final result = await client.searchPhotos(query: 'nature');
      expect(result.photos, hasLength(1));
      expect(result.totalResults, equals(100));
      expect(result.photos.first.photographer, equals('John Doe'));
    });

    test('getCuratedPhotos returns PhotoList', () async {
      final result = await client.getCuratedPhotos();
      expect(result.photos, hasLength(1));
      expect(result.page, equals(1));
    });

    test('getPhoto returns a single Photo', () async {
      final result = await client.getPhoto(id: 12345);
      expect(result.id, equals(12345));
      expect(result.photographer, equals('John Doe'));
      expect(result.src.medium, isNotEmpty);
    });

    test('searchPhotos sends correct query parameters', () async {
      final mockClient = http_testing.MockClient((request) async {
        expect(request.url.queryParameters['query'], equals('cats'));
        expect(request.url.queryParameters['page'], equals('2'));
        expect(request.url.queryParameters['per_page'], equals('10'));
        expect(request.url.queryParameters['orientation'], equals('landscape'));
        return http.Response(jsonEncode(_photoSearchResponse), 200);
      });

      final testClient = PexelsClient(apiKey: 'key', client: mockClient);
      await testClient.searchPhotos(
        query: 'cats',
        page: 2,
        perPage: 10,
        orientation: 'landscape',
      );
    });
  });

  group('Videos', () {
    test('searchVideos returns VideoList', () async {
      final result = await client.searchVideos(query: 'ocean');
      expect(result.videos, hasLength(1));
      expect(result.totalResults, equals(50));
      expect(result.videos.first.user.name, equals('Jane Smith'));
    });

    test('getPopularVideos returns VideoList', () async {
      final result = await client.getPopularVideos();
      expect(result.videos, hasLength(1));
    });

    test('getVideo returns a single Video', () async {
      final result = await client.getVideo(id: 67890);
      expect(result.id, equals(67890));
      expect(result.videoFiles, hasLength(1));
    });
  });

  group('Collections', () {
    test('getAllCollections returns CollectionList', () async {
      final result = await client.getAllCollections();
      expect(result.collections, hasLength(1));
      expect(result.collections.first.title, equals('Nature'));
    });

    test('getFeaturedCollections returns CollectionList', () async {
      final result = await client.getFeaturedCollections();
      expect(result.collections, hasLength(1));
    });

    test('getCollectionMedia returns CollectionMediaList', () async {
      final result = await client.getCollectionMedia(id: 'abc123');
      expect(result.media, hasLength(2));
      expect(result.media.first, isA<PhotoMediaItem>());
      expect(result.media.last, isA<VideoMediaItem>());
    });
  });

  group('Error handling', () {
    test('throws PexelsException on API error', () async {
      final errorClient = PexelsClient(
        apiKey: 'bad-key',
        client: http_testing.MockClient((_) async {
          return http.Response(
            jsonEncode({'error': 'Invalid API key'}),
            401,
          );
        }),
      );

      await expectLater(
        () => errorClient.searchPhotos(query: 'test'),
        throwsA(
          isA<PexelsException>()
              .having((e) => e.statusCode, 'statusCode', 401)
              .having((e) => e.message, 'message', 'Invalid API key'),
        ),
      );
    });
  });

  group('Client lifecycle', () {
    test('close does not close externally provided client', () {
      final mockHttpClient = http_testing.MockClient(
        (_) async => http.Response('{}', 200),
      );
      final pexelsClient = PexelsClient(
        apiKey: 'key',
        client: mockHttpClient,
      );
      // Should not throw - external client is not closed.
      pexelsClient.close();
    });
  });
}

// ---------------------------------------------------------------------------
// Test fixtures
// ---------------------------------------------------------------------------

const _singlePhoto = {
  'id': 12345,
  'width': 1920,
  'height': 1080,
  'url': 'https://www.pexels.com/photo/12345/',
  'alt': 'A beautiful landscape',
  'avg_color': '#A1B2C3',
  'photographer': 'John Doe',
  'photographer_url': 'https://www.pexels.com/@johndoe',
  'photographer_id': 111,
  'liked': false,
  'src': {
    'original': 'https://images.pexels.com/photos/12345/original.jpeg',
    'large2x': 'https://images.pexels.com/photos/12345/large2x.jpeg',
    'large': 'https://images.pexels.com/photos/12345/large.jpeg',
    'medium': 'https://images.pexels.com/photos/12345/medium.jpeg',
    'small': 'https://images.pexels.com/photos/12345/small.jpeg',
    'portrait': 'https://images.pexels.com/photos/12345/portrait.jpeg',
    'landscape': 'https://images.pexels.com/photos/12345/landscape.jpeg',
    'tiny': 'https://images.pexels.com/photos/12345/tiny.jpeg',
  },
};

const _photoSearchResponse = {
  'page': 1,
  'per_page': 15,
  'total_results': 100,
  'next_page': 'https://api.pexels.com/v1/search?page=2&query=nature',
  'photos': [_singlePhoto],
};

const _curatedResponse = {
  'page': 1,
  'per_page': 15,
  'next_page': 'https://api.pexels.com/v1/curated?page=2',
  'photos': [_singlePhoto],
};

const _singleVideo = {
  'id': 67890,
  'width': 1920,
  'height': 1080,
  'url': 'https://www.pexels.com/video/67890/',
  'image': 'https://images.pexels.com/videos/67890/thumb.jpeg',
  'duration': 30,
  'user': {
    'id': 222,
    'name': 'Jane Smith',
    'url': 'https://www.pexels.com/@janesmith',
  },
  'video_files': [
    {
      'id': 1,
      'quality': 'hd',
      'file_type': 'video/mp4',
      'width': 1920,
      'height': 1080,
      'link': 'https://videos.pexels.com/67890/hd.mp4',
      'fps': 30.0,
    },
  ],
  'video_pictures': [
    {
      'id': 1,
      'picture': 'https://images.pexels.com/videos/67890/pic-1.jpeg',
      'nr': 0,
    },
  ],
};

const _videoSearchResponse = {
  'page': 1,
  'per_page': 15,
  'total_results': 50,
  'next_page': 'https://api.pexels.com/videos/search?page=2&query=ocean',
  'videos': [_singleVideo],
};

const _videoPopularResponse = {
  'page': 1,
  'per_page': 15,
  'total_results': 200,
  'next_page': 'https://api.pexels.com/videos/popular?page=2',
  'videos': [_singleVideo],
};

const _collectionsResponse = {
  'page': 1,
  'per_page': 15,
  'collections': [
    {
      'id': 'abc123',
      'title': 'Nature',
      'description': 'Beautiful nature photos',
      'private': false,
      'media_count': 50,
      'photos_count': 40,
      'videos_count': 10,
    },
  ],
};

const _featuredCollectionsResponse = {
  'page': 1,
  'per_page': 15,
  'collections': [
    {
      'id': 'feat456',
      'title': 'Featured Nature',
      'description': null,
      'private': false,
      'media_count': 100,
      'photos_count': 80,
      'videos_count': 20,
    },
  ],
};

final _collectionMediaResponse = {
  'id': 'abc123',
  'page': 1,
  'per_page': 15,
  'total_results': 2,
  'media': [
    {..._singlePhoto, 'type': 'Photo'},
    {..._singleVideo, 'type': 'Video'},
  ],
};
