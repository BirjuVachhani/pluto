// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flat_color.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlatColor _$FlatColorFromJson(Map<String, dynamic> json) => FlatColor(
  name: json['name'] as String,
  background: const ColorConverter().fromJson(json['background'] as String),
  foreground: const ColorConverter().fromJson(json['foreground'] as String),
);

Map<String, dynamic> _$FlatColorToJson(FlatColor instance) => <String, dynamic>{
  'name': instance.name,
  'background': const ColorConverter().toJson(instance.background),
  'foreground': const ColorConverter().toJson(instance.foreground),
};
