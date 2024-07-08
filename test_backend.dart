// ignore_for_file: avoid_print
import 'package:celest_backend/client.dart';
import 'package:pluto/resources/unsplash_sources.dart';
import 'package:shared/shared.dart';
import 'package:unsplash_client/unsplash_client.dart';

void main() async {
  // Initialize Celest at the start of your app
  celest.init(environment: CelestEnvironment.local);

  const UnsplashSource source = UnsplashSources.aurora;
  final Photo? photo = await celest.functions.unsplash.randomUnsplashImage(
      source: source, orientation: UnsplashPhotoOrientation.landscape);
  if (photo == null) {
    print('Failed to fetch image');
    return;
  }
  print('-' * 100);
  print('Source: ${source.name}');
  print('URL: ${photo.urls.full}');
  print('Author: ${photo.user.name}');
  print('Resolution: ${photo.width}x${photo.height}');
  print('Tags: ${photo.tags?.map((tag) => tag.title).join(', ')}');
  print('-' * 100);
}
