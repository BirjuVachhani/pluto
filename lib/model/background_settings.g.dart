// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackgroundSettings _$BackgroundSettingsFromJson(Map<String, dynamic> json) =>
    BackgroundSettings(
      mode: $enumDecodeNullable(_$BackgroundModeEnumMap, json['mode']) ??
          BackgroundMode.color,
      color: json['color'] == null
          ? FlatColors.minimal
          : flatColorFromJson(json['color'] as String),
      gradient: json['gradient'] == null
          ? ColorGradients.youtube
          : colorGradientFromJson(json['gradient'] as String),
      tint: (json['tint'] as num?)?.toDouble() ?? 0,
      texture: json['texture'] as bool? ?? false,
      invert: json['invert'] as bool? ?? false,
      source: $enumDecodeNullable(_$ImageSourceEnumMap, json['source']) ??
          ImageSource.unsplash,
      unsplashSource: json['unsplashSource'] == null
          ? UnsplashSources.curated
          : UnsplashSource.fromJson(
              json['unsplashSource'] as Map<String, dynamic>),
      imageRefreshRate: $enumDecodeNullable(
              _$BackgroundRefreshRateEnumMap, json['imageRefreshRate']) ??
          BackgroundRefreshRate.never,
      imageResolution: $enumDecodeNullable(
              _$ImageResolutionEnumMap, json['imageResolution']) ??
          ImageResolution.auto,
      greyScale: json['greyScale'] as bool? ?? false,
      customSources: (json['customSources'] as List<dynamic>?)
          ?.map((e) => UnsplashSource.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BackgroundSettingsToJson(BackgroundSettings instance) =>
    <String, dynamic>{
      'mode': _$BackgroundModeEnumMap[instance.mode]!,
      'color': flatColorToJson(instance.color),
      'gradient': colorGradientToJson(instance.gradient),
      'tint': instance.tint,
      'texture': instance.texture,
      'invert': instance.invert,
      'source': _$ImageSourceEnumMap[instance.source]!,
      'unsplashSource': instance.unsplashSource,
      'imageRefreshRate':
          _$BackgroundRefreshRateEnumMap[instance.imageRefreshRate]!,
      'imageResolution': _$ImageResolutionEnumMap[instance.imageResolution]!,
      'greyScale': instance.greyScale,
      'customSources': instance.customSources,
    };

const _$BackgroundModeEnumMap = {
  BackgroundMode.color: 'color',
  BackgroundMode.gradient: 'gradient',
  BackgroundMode.image: 'image',
};

const _$ImageSourceEnumMap = {
  ImageSource.unsplash: 'unsplash',
  ImageSource.local: 'local',
  ImageSource.userLikes: 'userLikes',
};

const _$BackgroundRefreshRateEnumMap = {
  BackgroundRefreshRate.never: 'never',
  BackgroundRefreshRate.newTab: 'newTab',
  BackgroundRefreshRate.minute: 'minute',
  BackgroundRefreshRate.fiveMinute: 'fiveMinute',
  BackgroundRefreshRate.fifteenMinute: 'fifteenMinute',
  BackgroundRefreshRate.thirtyMinute: 'thirtyMinute',
  BackgroundRefreshRate.hour: 'hour',
  BackgroundRefreshRate.daily: 'daily',
  BackgroundRefreshRate.weekly: 'weekly',
};

const _$ImageResolutionEnumMap = {
  ImageResolution.auto: 'auto',
  ImageResolution.original: 'original',
  ImageResolution.hd: 'hd',
  ImageResolution.fullHd: 'fullHd',
  ImageResolution.quadHD: 'quadHD',
  ImageResolution.ultraHD: 'ultraHD',
  ImageResolution.fiveK: 'fiveK',
  ImageResolution.eightK: 'eightK',
};

UnsplashLikedBackground _$UnsplashLikedBackgroundFromJson(
        Map<String, dynamic> json) =>
    UnsplashLikedBackground(
      id: json['id'] as String,
      photo: Photo.fromJson(json['photo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UnsplashLikedBackgroundToJson(
        UnsplashLikedBackground instance) =>
    <String, dynamic>{
      'id': instance.id,
      'photo': instance.photo,
    };

UnsplashPhotoBackground _$UnsplashPhotoBackgroundFromJson(
        Map<String, dynamic> json) =>
    UnsplashPhotoBackground(
      id: json['id'] as String,
      bytes: base64Decode(json['bytes'] as String),
      photo: Photo.fromJson(json['photo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UnsplashPhotoBackgroundToJson(
        UnsplashPhotoBackground instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bytes': base64Encode(instance.bytes),
      'photo': instance.photo,
    };

Background _$BackgroundFromJson(Map<String, dynamic> json) => Background(
      url: json['url'] as String,
      id: json['id'] as String,
      bytes: base64Decode(json['bytes'] as String),
    );

Map<String, dynamic> _$BackgroundToJson(Background instance) =>
    <String, dynamic>{
      'url': instance.url,
      'id': instance.id,
      'bytes': base64Encode(instance.bytes),
    };

LikedBackground _$LikedBackgroundFromJson(Map<String, dynamic> json) =>
    LikedBackground(
      id: json['id'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$LikedBackgroundToJson(LikedBackground instance) =>
    <String, dynamic>{
      'url': instance.url,
      'id': instance.id,
    };
