// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionMediaList _$CollectionMediaListFromJson(Map<String, dynamic> json) =>
    CollectionMediaList(
      id: json['id'] as String,
      page: (json['page'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      totalResults: (json['total_results'] as num).toInt(),
      nextPage: json['next_page'] as String?,
      prevPage: json['prev_page'] as String?,
      media: CollectionMediaList._mediaFromJson(json['media'] as List),
    );
