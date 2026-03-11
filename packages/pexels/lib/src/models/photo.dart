import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';

/// Represents a photo from the Pexels API.
@JsonSerializable(fieldRename: FieldRename.snake)
class Photo {
  /// The unique identifier of the photo.
  final int id;

  /// The width of the photo in pixels.
  final int width;

  /// The height of the photo in pixels.
  final int height;

  /// The Pexels URL of the photo.
  final String url;

  /// The alt text of the photo.
  final String? alt;

  /// The average color of the photo as a hex string.
  final String? avgColor;

  /// The name of the photographer.
  final String photographer;

  /// The URL of the photographer's Pexels profile.
  final String photographerUrl;

  /// The unique identifier of the photographer.
  final int photographerId;

  /// Whether the current user has liked the photo.
  @JsonKey(defaultValue: false)
  final bool liked;

  /// An object containing different image sizes and formats.
  final PhotoSource src;

  const Photo({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    this.alt,
    this.avgColor,
    required this.photographer,
    required this.photographerUrl,
    required this.photographerId,
    required this.liked,
    required this.src,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}

/// Contains URLs for different sizes and formats of a [Photo].
@JsonSerializable()
class PhotoSource {
  /// The original size of the photo.
  final String original;

  /// The photo in W 940px X H 650px DPR 2.
  final String large2x;

  /// The photo in W 940px X H 650px DPR 1.
  final String large;

  /// The photo in H 350px.
  final String medium;

  /// The photo in H 130px.
  final String small;

  /// The photo cropped to W 800px X H 1200px.
  final String portrait;

  /// The photo cropped to W 1200px X H 627px.
  final String landscape;

  /// The photo cropped to W 280px X H 200px.
  final String tiny;

  const PhotoSource({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  factory PhotoSource.fromJson(Map<String, dynamic> json) =>
      _$PhotoSourceFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoSourceToJson(this);
}

/// A paginated list of [Photo] objects returned by the Pexels API.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class PhotoList {
  /// The current page number.
  final int page;

  /// The number of results per page.
  final int perPage;

  /// The total number of results (only available for search results).
  final int? totalResults;

  /// The URL of the next page of results.
  final String? nextPage;

  /// The URL of the previous page of results.
  final String? prevPage;

  /// The list of photos.
  final List<Photo> photos;

  const PhotoList({
    required this.page,
    required this.perPage,
    this.totalResults,
    this.nextPage,
    this.prevPage,
    required this.photos,
  });

  factory PhotoList.fromJson(Map<String, dynamic> json) =>
      _$PhotoListFromJson(json);
}
