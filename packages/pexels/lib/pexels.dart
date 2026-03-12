/// A comprehensive Dart client for the Pexels API.
///
/// Provides access to photos, videos, and collections from
/// [Pexels](https://www.pexels.com/).
///
/// ```dart
/// import 'package:pexels/pexels.dart';
///
/// final client = PexelsClient(apiKey: 'YOUR_API_KEY');
/// final photos = await client.searchPhotos(query: 'nature');
/// ```
library;

export 'src/models/collection.dart';
export 'src/models/media.dart';
export 'src/models/photo.dart';
export 'src/models/video.dart';
export 'src/pexels_client.dart';
export 'src/pexels_exception.dart';
export 'src/rate_limit_info.dart';
