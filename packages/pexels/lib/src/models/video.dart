import 'package:json_annotation/json_annotation.dart';

part 'video.g.dart';

/// Represents a video from the Pexels API.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class Video {
  /// The unique identifier of the video.
  final int id;

  /// The width of the video in pixels.
  final int width;

  /// The height of the video in pixels.
  final int height;

  /// The Pexels URL of the video.
  final String url;

  /// The URL of the video's thumbnail image.
  final String image;

  /// The duration of the video in seconds.
  final int duration;

  /// Raw full-resolution metadata (type is API-defined, may be null).
  final Object? fullRes;

  /// Tags associated with the video.
  @JsonKey(defaultValue: [])
  final List<dynamic> tags;

  /// The videographer who shot the video.
  final VideoUser user;

  /// A list of available video files in different qualities.
  final List<VideoFile> videoFiles;

  /// A list of preview pictures for the video.
  final List<VideoPicture> videoPictures;

  const Video({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.image,
    required this.duration,
    this.fullRes,
    this.tags = const [],
    required this.user,
    required this.videoFiles,
    required this.videoPictures,
  });

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
}

/// Represents the user/videographer who uploaded a [Video].
@JsonSerializable(createToJson: false)
class VideoUser {
  /// The unique identifier of the user.
  final int id;

  /// The name of the user.
  final String name;

  /// The URL of the user's Pexels profile.
  final String url;

  const VideoUser({
    required this.id,
    required this.name,
    required this.url,
  });

  factory VideoUser.fromJson(Map<String, dynamic> json) =>
      _$VideoUserFromJson(json);
}

/// Represents a single video file variant of a [Video].
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class VideoFile {
  /// The unique identifier of the video file.
  final int id;

  /// The quality of the video file (e.g., "hd", "sd", "hls").
  final String quality;

  /// The MIME type of the video file.
  final String fileType;

  /// The width of the video file in pixels.
  final int? width;

  /// The height of the video file in pixels.
  final int? height;

  /// The direct URL to the video file.
  final String link;

  /// The frames per second of the video file.
  final double? fps;

  const VideoFile({
    required this.id,
    required this.quality,
    required this.fileType,
    this.width,
    this.height,
    required this.link,
    this.fps,
  });

  factory VideoFile.fromJson(Map<String, dynamic> json) =>
      _$VideoFileFromJson(json);
}

/// Represents a preview picture of a [Video].
@JsonSerializable(createToJson: false)
class VideoPicture {
  /// The unique identifier of the video picture.
  final int id;

  /// The URL of the preview picture.
  final String picture;

  /// The index number of the picture.
  final int nr;

  const VideoPicture({
    required this.id,
    required this.picture,
    required this.nr,
  });

  factory VideoPicture.fromJson(Map<String, dynamic> json) =>
      _$VideoPictureFromJson(json);
}

/// A paginated list of [Video] objects returned by the Pexels API.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class VideoList {
  /// The current page number.
  final int page;

  /// The number of results per page.
  final int perPage;

  /// The total number of results.
  final int totalResults;

  /// The URL of the next page of results.
  final String? nextPage;

  /// The URL of the previous page of results.
  final String? prevPage;

  /// The list of videos.
  final List<Video> videos;

  const VideoList({
    required this.page,
    required this.perPage,
    required this.totalResults,
    this.nextPage,
    this.prevPage,
    required this.videos,
  });

  factory VideoList.fromJson(Map<String, dynamic> json) =>
      _$VideoListFromJson(json);
}
