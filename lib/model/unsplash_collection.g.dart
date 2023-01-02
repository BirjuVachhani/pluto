// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unsplash_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnsplashRandomSource _$UnsplashRandomSourceFromJson(
        Map<String, dynamic> json) =>
    UnsplashRandomSource(
      name: json['name'] as String? ?? 'Random',
    );

Map<String, dynamic> _$UnsplashRandomSourceToJson(
        UnsplashRandomSource instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

UnsplashCollectionSource _$UnsplashCollectionSourceFromJson(
        Map<String, dynamic> json) =>
    UnsplashCollectionSource(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$UnsplashCollectionSourceToJson(
        UnsplashCollectionSource instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
    };

UnsplashUserLikesSource _$UnsplashUserLikesSourceFromJson(
        Map<String, dynamic> json) =>
    UnsplashUserLikesSource(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$UnsplashUserLikesSourceToJson(
        UnsplashUserLikesSource instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
    };

UnsplashTagsSource _$UnsplashTagsSourceFromJson(Map<String, dynamic> json) =>
    UnsplashTagsSource(
      tags: json['tags'] as String,
    );

Map<String, dynamic> _$UnsplashTagsSourceToJson(UnsplashTagsSource instance) =>
    <String, dynamic>{
      'tags': instance.tags,
    };
