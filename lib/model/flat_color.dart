import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';
import 'package:json_annotation/json_annotation.dart';

import 'color_gradient.dart';

part 'flat_color.g.dart';

@JsonSerializable()
class FlatColor with EquatableMixin {
  final String name;
  @ColorConverter()
  final Color background;
  @ColorConverter()
  final Color foreground;

  const FlatColor({
    required this.name,
    required this.background,
    required this.foreground,
  });

  factory FlatColor.fromJson(Map<String, dynamic> json) => _$FlatColorFromJson(json);

  Map<String, dynamic> toJson() => _$FlatColorToJson(this);

  @override
  List<Object?> get props => [name, background, foreground];

  FlatColor copyWith({
    String? name,
    Color? background,
    Color? foreground,
  }) {
    return FlatColor(
      name: name ?? this.name,
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
    );
  }
}
