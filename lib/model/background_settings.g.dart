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
          ? UnsplashSources.random
          : UnsplashSource.fromJson(
              json['unsplashSource'] as Map<String, dynamic>),
      imageRefreshRate: $enumDecodeNullable(
              _$ImageRefreshRateEnumMap, json['imageRefreshRate']) ??
          ImageRefreshRate.never,
      imageIndex: json['imageIndex'] as int? ?? 0,
      imageResolution: $enumDecodeNullable(
              _$ImageResolutionEnumMap, json['imageResolution']) ??
          ImageResolution.auto,
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
      'imageRefreshRate': _$ImageRefreshRateEnumMap[instance.imageRefreshRate]!,
      'imageIndex': instance.imageIndex,
      'imageResolution': _$ImageResolutionEnumMap[instance.imageResolution]!,
    };

const _$BackgroundModeEnumMap = {
  BackgroundMode.color: 'color',
  BackgroundMode.gradient: 'gradient',
  BackgroundMode.image: 'image',
};

const _$ImageSourceEnumMap = {
  ImageSource.unsplash: 'unsplash',
  ImageSource.local: 'local',
};

const _$ImageRefreshRateEnumMap = {
  ImageRefreshRate.never: 'never',
  ImageRefreshRate.newTab: 'newTab',
  ImageRefreshRate.minute: 'minute',
  ImageRefreshRate.fiveMinute: 'fiveMinute',
  ImageRefreshRate.fifteenMinute: 'fifteenMinute',
  ImageRefreshRate.thirtyMinute: 'thirtyMinute',
  ImageRefreshRate.hour: 'hour',
  ImageRefreshRate.daily: 'daily',
  ImageRefreshRate.weekly: 'weekly',
};

const _$ImageResolutionEnumMap = {
  ImageResolution.auto: 'auto',
  ImageResolution.hd: 'hd',
  ImageResolution.fullHd: 'fullHd',
  ImageResolution.quadHD: 'quadHD',
  ImageResolution.ultraHD: 'ultraHD',
  ImageResolution.fiveK: 'fiveK',
  ImageResolution.eightK: 'eightK',
};
