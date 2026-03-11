// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Collection _$CollectionFromJson(Map<String, dynamic> json) => Collection(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  isPrivate: json['private'] as bool,
  mediaCount: (json['media_count'] as num).toInt(),
  photosCount: (json['photos_count'] as num).toInt(),
  videosCount: (json['videos_count'] as num).toInt(),
);

CollectionList _$CollectionListFromJson(Map<String, dynamic> json) =>
    CollectionList(
      page: (json['page'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      nextPage: json['next_page'] as String?,
      prevPage: json['prev_page'] as String?,
      totalResults: (json['total_results'] as num?)?.toInt(),
      collections: (json['collections'] as List<dynamic>)
          .map((e) => Collection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
