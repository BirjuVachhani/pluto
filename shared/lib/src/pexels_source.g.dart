// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pexels_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PexelsRandomSource _$PexelsRandomSourceFromJson(Map<String, dynamic> json) =>
    PexelsRandomSource(
      name: json['name'] as String? ?? 'Random',
    );

Map<String, dynamic> _$PexelsRandomSourceToJson(PexelsRandomSource instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

PexelsSearchSource _$PexelsSearchSourceFromJson(Map<String, dynamic> json) =>
    PexelsSearchSource(
      name: json['name'] as String,
      query: json['query'] as String,
    );

Map<String, dynamic> _$PexelsSearchSourceToJson(PexelsSearchSource instance) =>
    <String, dynamic>{
      'name': instance.name,
      'query': instance.query,
    };
