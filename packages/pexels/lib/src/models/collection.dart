import 'package:json_annotation/json_annotation.dart';

part 'collection.g.dart';

/// Represents a collection from the Pexels API.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class Collection {
  /// The unique identifier of the collection.
  final String id;

  /// The title of the collection.
  final String title;

  /// The description of the collection.
  final String? description;

  /// Whether the collection is private.
  @JsonKey(name: 'private')
  final bool isPrivate;

  /// The total number of media items in the collection.
  final int mediaCount;

  /// The number of photos in the collection.
  final int photosCount;

  /// The number of videos in the collection.
  final int videosCount;

  const Collection({
    required this.id,
    required this.title,
    this.description,
    required this.isPrivate,
    required this.mediaCount,
    required this.photosCount,
    required this.videosCount,
  });

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);
}

/// A paginated list of [Collection] objects returned by the Pexels API.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class CollectionList {
  /// The current page number.
  final int page;

  /// The number of results per page.
  final int perPage;

  /// The URL of the next page of results.
  final String? nextPage;

  /// The total number of results.
  final int? totalResults;

  /// The URL of the previous page of results.
  final String? prevPage;

  /// The list of collections.
  final List<Collection> collections;

  const CollectionList({
    required this.page,
    required this.perPage,
    this.nextPage,
    this.prevPage,
    this.totalResults,
    required this.collections,
  });

  factory CollectionList.fromJson(Map<String, dynamic> json) =>
      _$CollectionListFromJson(json);
}
