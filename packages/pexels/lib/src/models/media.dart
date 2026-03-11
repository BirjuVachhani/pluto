import 'package:json_annotation/json_annotation.dart';

import 'photo.dart';
import 'video.dart';

part 'media.g.dart';

/// Represents a media item from a collection, which can be either a
/// [Photo] or a [Video].
sealed class MediaItem {
  const MediaItem();

  /// Creates a [MediaItem] from a JSON map.
  ///
  /// The JSON must contain a `type` field with a value of either
  /// `"Photo"` or `"Video"`.
  factory MediaItem.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    return switch (type) {
      'Photo' => PhotoMediaItem(photo: Photo.fromJson(json)),
      'Video' => VideoMediaItem(video: Video.fromJson(json)),
      _ => throw FormatException('Unknown media type: $type'),
    };
  }
}

/// A [MediaItem] that wraps a [Photo].
class PhotoMediaItem extends MediaItem {
  /// The photo data.
  final Photo photo;

  const PhotoMediaItem({required this.photo});
}

/// A [MediaItem] that wraps a [Video].
class VideoMediaItem extends MediaItem {
  /// The video data.
  final Video video;

  const VideoMediaItem({required this.video});
}

/// A paginated list of [MediaItem] objects from a collection.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class CollectionMediaList {
  /// The unique identifier of the collection.
  final String id;

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

  /// The list of media items.
  @JsonKey(fromJson: _mediaFromJson)
  final List<MediaItem> media;

  const CollectionMediaList({
    required this.id,
    required this.page,
    required this.perPage,
    required this.totalResults,
    this.nextPage,
    this.prevPage,
    required this.media,
  });

  factory CollectionMediaList.fromJson(Map<String, dynamic> json) =>
      _$CollectionMediaListFromJson(json);

  static List<MediaItem> _mediaFromJson(List<dynamic> json) =>
      json
          .map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
          .toList();
}
