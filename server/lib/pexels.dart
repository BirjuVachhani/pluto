import 'dart:math';

import 'package:pexels/pexels.dart' as pexels;
import 'package:shared/shared.dart';

import 'unsplash.dart' show env;

Future<pexels.Photo?> randomPexelsImage({
  required PexelsSource source,
}) async {
  final String? pexelsApiKey = env['PEXLES_API_KEY'];
  if (pexelsApiKey == null) {
    throw StateError('PEXLES_API_KEY is missing.');
  }
  final client = pexels.PexelsClient(apiKey: pexelsApiKey);

  try {
    switch (source) {
      case PexelsSearchSource source:
        final randomPage = Random().nextInt(100) + 1;
        final result = await client.searchPhotos(
          query: source.query,
          page: randomPage,
          perPage: 1,
          orientation: 'landscape',
        );
        return result.photos.firstOrNull;
      case PexelsRandomSource():
        final randomPage = Random().nextInt(100) + 1;
        final result = await client.getCuratedPhotos(
          page: randomPage,
          perPage: 1,
        );
        return result.photos.firstOrNull;
    }
  } finally {
    client.close();
  }
}
