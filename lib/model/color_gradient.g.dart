// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_gradient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ColorGradient _$ColorGradientFromJson(Map<String, dynamic> json) => ColorGradient(
  name: json['name'] as String,
  colors: const ColorListConverter().fromJson(
    json['colors'] as List<String>,
  ),
  begin: const AlignmentConverter().fromJson(json['begin'] as String),
  end: const AlignmentConverter().fromJson(json['end'] as String),
  foreground: const ColorConverter().fromJson(json['foreground'] as String),
  stops: (json['stops'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? const [],
);

Map<String, dynamic> _$ColorGradientToJson(ColorGradient instance) => <String, dynamic>{
  'name': instance.name,
  'colors': const ColorListConverter().toJson(instance.colors),
  'begin': const AlignmentConverter().toJson(instance.begin),
  'end': const AlignmentConverter().toJson(instance.end),
  'stops': instance.stops,
  'foreground': const ColorConverter().toJson(instance.foreground),
};
