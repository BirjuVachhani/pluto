// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Photo _$PhotoFromJson(Map<String, dynamic> json) => Photo(
  id: (json['id'] as num).toInt(),
  width: (json['width'] as num).toInt(),
  height: (json['height'] as num).toInt(),
  url: json['url'] as String,
  alt: json['alt'] as String?,
  avgColor: json['avg_color'] as String?,
  photographer: json['photographer'] as String,
  photographerUrl: json['photographer_url'] as String,
  photographerId: (json['photographer_id'] as num).toInt(),
  liked: json['liked'] as bool? ?? false,
  src: PhotoSource.fromJson(json['src'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
  'id': instance.id,
  'width': instance.width,
  'height': instance.height,
  'url': instance.url,
  'alt': instance.alt,
  'avg_color': instance.avgColor,
  'photographer': instance.photographer,
  'photographer_url': instance.photographerUrl,
  'photographer_id': instance.photographerId,
  'liked': instance.liked,
  'src': instance.src,
};

PhotoSource _$PhotoSourceFromJson(Map<String, dynamic> json) => PhotoSource(
  original: json['original'] as String,
  large2x: json['large2x'] as String,
  large: json['large'] as String,
  medium: json['medium'] as String,
  small: json['small'] as String,
  portrait: json['portrait'] as String,
  landscape: json['landscape'] as String,
  tiny: json['tiny'] as String,
);

Map<String, dynamic> _$PhotoSourceToJson(PhotoSource instance) =>
    <String, dynamic>{
      'original': instance.original,
      'large2x': instance.large2x,
      'large': instance.large,
      'medium': instance.medium,
      'small': instance.small,
      'portrait': instance.portrait,
      'landscape': instance.landscape,
      'tiny': instance.tiny,
    };

PhotoList _$PhotoListFromJson(Map<String, dynamic> json) => PhotoList(
  page: (json['page'] as num).toInt(),
  perPage: (json['per_page'] as num).toInt(),
  totalResults: (json['total_results'] as num?)?.toInt(),
  nextPage: json['next_page'] as String?,
  prevPage: json['prev_page'] as String?,
  photos: (json['photos'] as List<dynamic>)
      .map((e) => Photo.fromJson(e as Map<String, dynamic>))
      .toList(),
);
