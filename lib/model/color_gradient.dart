import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';

class ColorGradient with EquatableMixin {
  final String name;
  final List<Color> colors;
  final Alignment begin;
  final Alignment end;
  final List<double> stops;
  final Color foreground;

  const ColorGradient({
    required this.name,
    required this.colors,
    required this.begin,
    required this.end,
    required this.foreground,
    this.stops = const [],
  });

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
