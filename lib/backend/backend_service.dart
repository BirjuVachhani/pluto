import 'package:pexels/pexels.dart' as pexels;
import 'package:shared/shared.dart';
import 'package:unsplash_client/unsplash_client.dart';

abstract class BackendService {
  Future<void> init({bool local = false});

  Future<Photo?> randomUnsplashImage({
    required UnsplashSource source,
    required UnsplashPhotoOrientation orientation,
  });

  Future<pexels.Photo?> randomPexelsImage({
    required PexelsSource source,
  });
}
