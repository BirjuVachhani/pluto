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
    );

Map<String, dynamic> _$BackgroundSettingsToJson(BackgroundSettings instance) =>
    <String, dynamic>{
      'mode': _$BackgroundModeEnumMap[instance.mode]!,
      'color': flatColorToJson(instance.color),
      'gradient': colorGradientToJson(instance.gradient),
      'tint': instance.tint,
      'texture': instance.texture,
      'invert': instance.invert,
    };

const _$BackgroundModeEnumMap = {
  BackgroundMode.color: 'color',
  BackgroundMode.gradient: 'gradient',
  BackgroundMode.image: 'image',
};
