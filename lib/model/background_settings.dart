import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../resources/color_gradients.dart';
import '../resources/flat_colors.dart';
import '../resources/unsplash_sources.dart';
import '../utils/utils.dart';
import 'color_gradient.dart';
import 'flat_color.dart';
import 'unsplash_collection.dart';

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

enum ImageSource { unsplash, local }

enum ImageRefreshRate {
  never('Never', Duration(days: 365)),
  newTab('Every New Tab', Duration(days: 365)),
  minute('Every Minute', Duration(minutes: 1)),
  fiveMinute('Every 5 Minute', Duration(minutes: 5)),
  fifteenMinute('Every 15 Minute', Duration(minutes: 5)),
  thirtyMinute('Every 30 Minute', Duration(minutes: 5)),
  hour('Every hour', Duration(hours: 1)),
  daily('Every Day', Duration(days: 1)),
  weekly('Every Week', Duration(days: 7));

  const ImageRefreshRate(this.label, this.duration);

  final String label;
  final Duration duration;

  bool get requiresTimer =>
      this != ImageRefreshRate.never && this != ImageRefreshRate.newTab;

  bool get isShort {
    switch (this) {
      case ImageRefreshRate.minute:
      case ImageRefreshRate.fiveMinute:
      case ImageRefreshRate.fifteenMinute:
      case ImageRefreshRate.thirtyMinute:
      case ImageRefreshRate.hour:
        return true;
      case ImageRefreshRate.never:
      case ImageRefreshRate.newTab:
      case ImageRefreshRate.daily:
      case ImageRefreshRate.weekly:
        return false;
    }
  }
}

enum ImageResolution {
  auto('Auto'),
  hd('HD'),
  fullHd('FHD'),
  quadHD('2K'),
  ultraHD('4K'),
  fiveK('5K'),
  eightK('8K');

  const ImageResolution(this.label);

  final String label;
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
  final ImageSource source;
  final UnsplashSource unsplashSource;
  final ImageRefreshRate imageRefreshRate;
  final int imageIndex;
  final ImageResolution imageResolution;

  BackgroundSettings({
    this.mode = BackgroundMode.color,
    this.color = FlatColors.minimal,
    this.gradient = ColorGradients.youtube,
    this.tint = 0,
    this.texture = false,
    this.invert = false,
    this.source = ImageSource.unsplash,
    this.unsplashSource = UnsplashSources.random,
    this.imageRefreshRate = ImageRefreshRate.never,
    this.imageIndex = 0,
    this.imageResolution = ImageResolution.auto,
  });

  @override
  List<Object?> get props => [
        mode,
        color,
        gradient,
        tint,
        texture,
        invert,
        source,
        unsplashSource,
        imageRefreshRate,
        imageIndex,
        imageResolution,
      ];

  BackgroundSettings copyWith({
    BackgroundMode? mode,
    FlatColor? color,
    ColorGradient? gradient,
    double? tint,
    bool? texture,
    bool? invert,
    ImageSource? source,
    UnsplashSource? unsplashSource,
    ImageRefreshRate? imageRefreshRate,
    int? imageIndex,
    ImageResolution? imageResolution,
  }) {
    return BackgroundSettings(
      mode: mode ?? this.mode,
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      tint: tint ?? this.tint,
      texture: texture ?? this.texture,
      invert: invert ?? this.invert,
      source: source ?? this.source,
      unsplashSource: unsplashSource ?? this.unsplashSource,
      imageRefreshRate: imageRefreshRate ?? this.imageRefreshRate,
      imageIndex: imageIndex ?? this.imageIndex,
      imageResolution: imageResolution ?? this.imageResolution,
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
