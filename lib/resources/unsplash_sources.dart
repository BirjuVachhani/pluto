import 'package:shared/shared.dart';

class UnsplashSources {
  const UnsplashSources._();

  static const UnsplashRandomSource random = UnsplashRandomSource();

  // static const UnsplashUserLikesSource curated =
  //     UnsplashUserLikesSource(name: 'Curated by Pluto', id: 'birjuvachhani');
  static const UnsplashCollectionSource curated =
      UnsplashCollectionSource(name: 'Curated by Pluto', id: 'wRzsGAB4Jcg');
  static const UnsplashCollectionSource christmas =
      UnsplashCollectionSource(name: 'Christmas', id: '2340020');
  static const UnsplashCollectionSource nature =
      UnsplashCollectionSource(name: 'Nature', id: '3330448');
  static const UnsplashCollectionSource wallpapers =
      UnsplashCollectionSource(name: 'Wallpapers', id: '1065976');
  static const UnsplashCollectionSource texturesAndPatterns =
      UnsplashCollectionSource(name: 'Textures & Patterns', id: '3330445');
  static const UnsplashCollectionSource experimental =
      UnsplashCollectionSource(name: 'Experimental', id: '9510092');
  static const UnsplashCollectionSource floralBeauty =
      UnsplashCollectionSource(name: 'Floral Beauty', id: '17098');
  static const UnsplashCollectionSource film =
      UnsplashCollectionSource(name: 'Film', id: '4694315');
  static const UnsplashCollectionSource lushLife =
      UnsplashCollectionSource(name: 'Lush Life', id: '9270463');
  static const UnsplashCollectionSource architecture =
      UnsplashCollectionSource(name: 'Architecture', id: '3348849');
  static const UnsplashCollectionSource aurora =
      UnsplashCollectionSource(name: 'Aurora', id: '9670693');

  static const List<UnsplashSource> sources = [
    random,
    curated,
    christmas,
    nature,
    wallpapers,
    texturesAndPatterns,
    experimental,
    floralBeauty,
    film,
    lushLife,
    architecture,
    aurora,
  ];
}
