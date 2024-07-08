// Cloud functions are top-level Dart functions defined in the `functions/`
// folder of your Celest project.

import 'package:celest/celest.dart';
import 'package:shared/shared.dart';
import 'package:unsplash_client/unsplash_client.dart';

import '../generated/resources.dart';

@cloud
Future<Photo?> randomUnsplashImage({
  required UnsplashSource source,
  UnsplashPhotoOrientation? orientation = UnsplashPhotoOrientation.landscape,
  @env.unsplashAccessKey required String unsplashAccessKey,
}) async {
  final client = UnsplashClient(
    settings: ClientSettings(
      credentials: AppCredentials(accessKey: unsplashAccessKey),
    ),
  );

  switch (source) {
    case UnsplashCollectionSource source:
      final List<Photo> result = await client.photos.random(
        count: 1,
        orientation: PhotoOrientation.landscape,
        collections: [source.id],
      ).goAndGet();
      return result.firstOrNull;
    case UnsplashTagsSource source:
      final List<Photo> result = await client.photos
          .random(
            count: 1,
            orientation: PhotoOrientation.landscape,
            query: source.tags,
          )
          .goAndGet();
      return result.firstOrNull;
    case UnsplashRandomSource():
    case UnsplashUserLikesSource():
      final List<Photo> result = await client.photos
          .random(
            count: 1,
            orientation: PhotoOrientation.landscape,
          )
          .goAndGet();
      return result.firstOrNull;
    // case UnsplashUserLikesSource source:
    //   final List<Photo> result = await client.photos.random(
    //     count: 1,
    //     orientation: PhotoOrientation.landscape,
    //     username: source.id,
    //   ).goAndGet();
    //   return result.firstOrNull;
  }
}
