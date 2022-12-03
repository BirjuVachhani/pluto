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

UnsplashUserSource _$UnsplashUserSourceFromJson(Map<String, dynamic> json) =>
    UnsplashUserSource(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$UnsplashUserSourceToJson(UnsplashUserSource instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
    };

UnsplashLikesSource _$UnsplashLikesSourceFromJson(Map<String, dynamic> json) =>
    UnsplashLikesSource(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$UnsplashLikesSourceToJson(
        UnsplashLikesSource instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
    };
