import 'package:shared/shared.dart';

class PexelsSources {
  const PexelsSources._();

  static const PexelsRandomSource random = PexelsRandomSource();

  static const PexelsSearchSource nature =
      PexelsSearchSource(name: 'Nature', query: 'nature');
  static const PexelsSearchSource wallpapers =
      PexelsSearchSource(name: 'Wallpapers', query: 'wallpapers');
  static const PexelsSearchSource texturesAndPatterns =
      PexelsSearchSource(name: 'Textures & Patterns', query: 'textures patterns');
  static const PexelsSearchSource experimental =
      PexelsSearchSource(name: 'Experimental', query: 'experimental abstract');
  static const PexelsSearchSource floralBeauty =
      PexelsSearchSource(name: 'Floral Beauty', query: 'floral flowers');
  static const PexelsSearchSource film =
      PexelsSearchSource(name: 'Film', query: 'film analog');
  static const PexelsSearchSource lushLife =
      PexelsSearchSource(name: 'Lush Life', query: 'lush tropical');
  static const PexelsSearchSource architecture =
      PexelsSearchSource(name: 'Architecture', query: 'architecture');
  static const PexelsSearchSource aurora =
      PexelsSearchSource(name: 'Aurora', query: 'aurora borealis');
  static const PexelsSearchSource christmas =
      PexelsSearchSource(name: 'Christmas', query: 'christmas');

  static const List<PexelsSource> sources = [
    random,
    nature,
    wallpapers,
    texturesAndPatterns,
    experimental,
    floralBeauty,
    film,
    lushLife,
    architecture,
    aurora,
    christmas,
  ];
}
