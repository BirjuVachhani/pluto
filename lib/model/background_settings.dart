import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../resources/color_gradients.dart';
import '../resources/flat_colors.dart';
import '../utils/utils.dart';
import 'color_gradient.dart';
import 'flat_color.dart';

part 'background_settings.g.dart';

enum BackgroundMode {
  color('Color'),
  gradient('Gradient'),
  image('Image');

  const BackgroundMode(this.label);

  final String label;

  bool get isColor => this == BackgroundMode.color;

  bool get isGradient => this == BackgroundMode.gradient;

  bool get isImage => this == BackgroundMode.image;
}

@JsonSerializable()
class BackgroundSettings with EquatableMixin {
  final BackgroundMode mode;

  @JsonKey(toJson: flatColorToJson, fromJson: flatColorFromJson)
  final FlatColor color;

  @JsonKey(toJson: colorGradientToJson, fromJson: colorGradientFromJson)
  final ColorGradient gradient;
  final double tint;
  final bool texture;
  final bool invert;

  BackgroundSettings({
    this.mode = BackgroundMode.color,
    this.color = FlatColors.minimal,
    this.gradient = ColorGradients.youtube,
    this.tint = 0,
    this.texture = false,
    this.invert = false,
  });

  @override
  List<Object?> get props => [mode, color, gradient, tint, texture, invert];

  BackgroundSettings copyWith({
    BackgroundMode? mode,
    FlatColor? color,
    ColorGradient? gradient,
    double? tint,
    bool? texture,
    bool? invert,
  }) {
    return BackgroundSettings(
      mode: mode ?? this.mode,
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      tint: tint ?? this.tint,
      texture: texture ?? this.texture,
      invert: invert ?? this.invert,
    );
  }

  factory BackgroundSettings.fromJson(Map<String, dynamic> json) =>
      _$BackgroundSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$BackgroundSettingsToJson(this);
}

FlatColor flatColorFromJson(String name) =>
    findColorByName(name) ?? FlatColors.minimal;

ColorGradient colorGradientFromJson(String name) =>
    findGradientByName(name) ?? ColorGradients.youtube;

String flatColorToJson(FlatColor color) => color.name;

String colorGradientToJson(ColorGradient gradient) => gradient.name;
