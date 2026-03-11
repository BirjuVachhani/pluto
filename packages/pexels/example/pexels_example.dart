import 'package:pexels/pexels.dart';

void main() async {
  final client = PexelsClient(apiKey: 'YOUR_API_KEY');

  try {
    // Search for photos
    final photos = await client.searchPhotos(query: 'nature', perPage: 5);
    print('Found ${photos.totalResults} photos');
    for (final photo in photos.photos) {
      print('  ${photo.photographer}: ${photo.src.medium}');
    }

    // Get a random photo
    final random = await client.getRandomPhoto();
    print('Random photo by ${random.photographer}');

    // Search for videos
    final videos = await client.searchVideos(query: 'ocean', perPage: 3);
    print('Found ${videos.totalResults} videos');
    for (final video in videos.videos) {
      print('  ${video.user.name}: ${video.url}');
    }

    // Browse featured collections
    final collections = await client.getFeaturedCollections(perPage: 5);
    for (final collection in collections.collections) {
      print('  ${collection.title} (${collection.mediaCount} items)');
    }
  } on PexelsException catch (e) {
    print('API error: $e');
  } finally {
    client.close();
  }
}
