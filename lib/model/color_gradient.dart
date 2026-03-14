import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:json_annotation/json_annotation.dart';

part 'color_gradient.g.dart';

@JsonSerializable()
class ColorGradient with EquatableMixin {
  final String name;
  @ColorListConverter()
  final List<Color> colors;
  @AlignmentConverter()
  final Alignment begin;
  @AlignmentConverter()
  final Alignment end;
  final List<double> stops;
  @ColorConverter()
  final Color foreground;

  const ColorGradient({
    required this.name,
    required this.colors,
    required this.begin,
    required this.end,
    required this.foreground,
    this.stops = const [],
  });

  factory ColorGradient.fromJson(Map<String, dynamic> json) => _$ColorGradientFromJson(json);

  Map<String, dynamic> toJson() => _$ColorGradientToJson(this);

  @override
  List<Object?> get props => [name, colors, begin, end, stops, foreground];

  ColorGradient copyWith({
    String? name,
    List<Color>? colors,
    Alignment? begin,
    Alignment? end,
    List<double>? stops,
    Color? foreground,
  }) {
    return ColorGradient(
      name: name ?? this.name,
      colors: colors ?? this.colors,
      begin: begin ?? this.begin,
      end: end ?? this.end,
      stops: stops ?? this.stops,
      foreground: foreground ?? this.foreground,
    );
  }
}

class AlignmentConverter implements JsonConverter<Alignment, String> {
  const AlignmentConverter();

  @override
  Alignment fromJson(String json) {
    return switch (json) {
      'topLeft' => Alignment.topLeft,
      'topCenter' => Alignment.topCenter,
      'topRight' => Alignment.topRight,
      'centerLeft' => Alignment.centerLeft,
      'center' => Alignment.center,
      'centerRight' => Alignment.centerRight,
      'bottomLeft' => Alignment.bottomLeft,
      'bottomCenter' => Alignment.bottomCenter,
      'bottomRight' => Alignment.bottomRight,
      _ => throw ArgumentError('Unknown alignment: $json'),
    };
  }

  @override
  String toJson(Alignment object) => switch (object) {
    Alignment.topLeft => 'topLeft',
    Alignment.topCenter => 'topCenter',
    Alignment.topRight => 'topRight',
    Alignment.centerLeft => 'centerLeft',
    Alignment.center => 'center',
    Alignment.centerRight => 'centerRight',
    Alignment.bottomLeft => 'bottomLeft',
    Alignment.bottomCenter => 'bottomCenter',
    Alignment.bottomRight => 'bottomRight',
    _ => throw ArgumentError('Unknown alignment: $object'),
  };
}

class ColorConverter implements JsonConverter<Color, String> {
  const ColorConverter();

  @override
  Color fromJson(String hex) => hex.toColor()!;

  @override
  String toJson(Color color) => color.hexString;
}

class ColorListConverter implements JsonConverter<List<Color>, List<String>> {
  const ColorListConverter();

  @override
  List<Color> fromJson(List<String> colors) => colors.map((color) => color.toColor()!).toList();

  @override
  List<String> toJson(List<Color> colors) => colors.map((color) => color.hexString).toList();
}
