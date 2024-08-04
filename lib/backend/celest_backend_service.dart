import 'dart:developer';

import 'package:celest_backend/client.dart';
import 'package:shared/shared.dart';
import 'package:unsplash_client/unsplash_client.dart';

import 'backend_service.dart';

class CelestBackendService extends BackendService {
  @override
  Future<void> init({bool local = false}) async {
    // Initialize Celest at the start of your app
    bool celestInitialized = false;

    if (local) {
      log('Initializing Celest with local server');
      celest.init(environment: CelestEnvironment.local);
      celestInitialized = true;
    }

    if (!celestInitialized) {
      log('Initializing Celest with production server');
      celest.init(environment: CelestEnvironment.production);
    }
  }

  @override
  Future<Photo?> randomUnsplashImage({
    required UnsplashSource source,
    required UnsplashPhotoOrientation orientation,
  }) =>
      celest.functions.unsplash
          .randomUnsplashImage(source: source, orientation: orientation);
}
