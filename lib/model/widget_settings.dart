import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:screwdriver/screwdriver.dart';

import '../resources/fonts.dart';
import 'color_gradient.dart';

part 'widget_settings.g.dart';

enum WidgetType {
  none('Nothing'),
  digitalClock('Digital Clock'),
  analogClock('Analog Clock'),
  text('Message'),
  timer('Timer'),
  weather('Weather'),
  digitalDate('Date & Time')
  ;
  // calendar('Calendar');

  const WidgetType(this.label);

  final String label;
}

enum ClockFormat {
  twelveHour('12 Hours'),
  twelveHoursWithAmPm('12 Hours with AM / PM'),
  twentyFourHour('24 Hours')
  ;

  const ClockFormat(this.label);

  final String label;
}

enum DateFormat {
  dayMonthYear,
  monthDayYear,
  yearMonthDay,
  custom
  ;

  String prettify(String separator) {
    return switch (this) {
      dayMonthYear => 'dd${separator}mm${separator}yyyy',
      monthDayYear => 'mm${separator}dd${separator}yyyy',
      yearMonthDay => 'yyyy${separator}mm${separator}dd',
      custom => 'Custom',
    };
  }
}

// enum DateFormat {
//   dayMonthYear('dd/mm/yyyy'),
//   monthDayYear('mm/dd/yyyy'),
//   yearMonthDay('yyyy/mm/dd'),
//   special('Custom');

//   const DateFormat(this.label);

//   final String label;
// }

enum Separator {
  nothing(''),
  dot('•'),
  colon(':'),
  dash('-'),
  space(' '),
  newLine('\n')
  ;

  const Separator(this.value);

  final String value;
}

enum DateSeparator {
  dash('-'),
  dot('•'),
  slash('/')
  ;

  const DateSeparator(this.value);

  final String value;
}

enum AlignmentC {
  topLeft('Top Left'),
  topCenter('Top Center'),
  topRight('Top Right'),
  centerLeft('Center Left'),
  center('Center'),
  centerRight('Center Right'),
  bottomLeft('Bottom Left'),
  bottomCenter('Bottom Center'),
  bottomRight('Bottom Right')
  ;

  const AlignmentC(this.label);

  final String label;
}

enum WidgetBackgroundType {
  none('None'),
  color('Color'),
  glass('Glass'),
  border('Border')
  ;

  const WidgetBackgroundType(this.label);

  final String label;
}

sealed class WidgetDecoration with SerializableMixin, EquatableMixin {
  @JsonKey(includeToJson: true)
  final WidgetBackgroundType type;
  final double borderRadius;

  /// When non-null, this decoration's color is bound to an image palette
  /// color identified by this key (e.g. "dominant", "vibrant", "palette_3").
  /// When the background image changes, the color is automatically updated
  /// to match the same palette slot in the new image.
  final String? imageColorId;

  const WidgetDecoration({
    required this.type,
    this.borderRadius = 0,
    this.imageColorId,
  });

  factory WidgetDecoration.fromJson(Map<String, dynamic> json) {
    final WidgetBackgroundType type = json['type'] != null
        ? WidgetBackgroundType.values.byName(json['type'])
        : WidgetBackgroundType.none;
    switch (type) {
      case WidgetBackgroundType.none:
        return NoDecoration.fromJson(json);
      case WidgetBackgroundType.color:
        return ColorDecoration.fromJson(json);
      case WidgetBackgroundType.glass:
        return GlassDecoration.fromJson(json);
      case WidgetBackgroundType.border:
        return BorderDecoration.fromJson(json);
    }
  }

  /// Returns a copy of this decoration with the given [imageColorId].
  WidgetDecoration withImageColorId(String? imageColorId);

  /// Returns a copy of this decoration with the given [color], preserving
  /// all other properties.
  WidgetDecoration withColor(Color color);

  @override
  List<Object?> get props => [type, borderRadius, imageColorId];
}

@JsonSerializable()
final class NoDecoration extends WidgetDecoration {
  const NoDecoration() : super(type: WidgetBackgroundType.none);

  factory NoDecoration.fromJson(Map<String, dynamic> json) => _$NoDecorationFromJson(json);

  @override
  JsonMap toJson() => _$NoDecorationToJson(this);

  @override
  NoDecoration withImageColorId(String? imageColorId) => const NoDecoration();

  @override
  NoDecoration withColor(Color color) => const NoDecoration();
}

@JsonSerializable()
final class ColorDecoration extends WidgetDecoration {
  @ColorConverter()
  final Color color;
  final double opacity;

  const ColorDecoration({
    required this.color,
    this.opacity = 1,
    super.borderRadius,
    super.imageColorId,
  }) : super(type: WidgetBackgroundType.color);

  static const ColorDecoration dark = ColorDecoration(color: Color(0xFF000000), opacity: 1);

  static const ColorDecoration light = ColorDecoration(color: Color(0xFFFFFFFF), opacity: 1);

  factory ColorDecoration.fromJson(Map<String, dynamic> json) => _$ColorDecorationFromJson(json);

  @override
  JsonMap toJson() => _$ColorDecorationToJson(this);

  @override
  ColorDecoration withImageColorId(String? imageColorId) => ColorDecoration(
    color: color,
    opacity: opacity,
    borderRadius: borderRadius,
    imageColorId: imageColorId,
  );

  @override
  ColorDecoration withColor(Color color) => ColorDecoration(
    color: color,
    opacity: opacity,
    borderRadius: borderRadius,
    imageColorId: imageColorId,
  );

  @override
  List<Object?> get props => [...super.props, color, opacity];
}

@JsonSerializable()
final class GlassDecoration extends WidgetDecoration {
  @ColorConverter()
  final Color tint;
  final double tintOpacity;
  final double blur;

  const GlassDecoration({
    this.tint = const Color(0x80FFFFFF),
    this.tintOpacity = 1,
    this.blur = 20,
    super.borderRadius,
    super.imageColorId,
  }) : super(type: WidgetBackgroundType.glass);

  factory GlassDecoration.fromJson(Map<String, dynamic> json) => _$GlassDecorationFromJson(json);

  @override
  JsonMap toJson() => _$GlassDecorationToJson(this);

  @override
  GlassDecoration withImageColorId(String? imageColorId) => GlassDecoration(
    tint: tint,
    tintOpacity: tintOpacity,
    blur: blur,
    borderRadius: borderRadius,
    imageColorId: imageColorId,
  );

  @override
  GlassDecoration withColor(Color color) => GlassDecoration(
    tint: color,
    tintOpacity: tintOpacity,
    blur: blur,
    borderRadius: borderRadius,
    imageColorId: imageColorId,
  );

  @override
  List<Object?> get props => [...super.props, tint, tintOpacity, blur];
}

@JsonSerializable()
final class BorderDecoration extends WidgetDecoration {
  @ColorConverter()
  final Color color;
  final double opacity;
  final double thickness;

  const BorderDecoration({
    this.color = const Color(0xFFFFFFFF),
    this.opacity = 1,
    this.thickness = 1,
    super.borderRadius,
    super.imageColorId,
  }) : super(type: WidgetBackgroundType.border);

  factory BorderDecoration.fromJson(Map<String, dynamic> json) => _$BorderDecorationFromJson(json);

  @override
  JsonMap toJson() => _$BorderDecorationToJson(this);

  @override
  BorderDecoration withImageColorId(String? imageColorId) => BorderDecoration(
    color: color,
    opacity: opacity,
    thickness: thickness,
    borderRadius: borderRadius,
    imageColorId: imageColorId,
  );

  @override
  BorderDecoration withColor(Color color) => BorderDecoration(
    color: color,
    opacity: opacity,
    thickness: thickness,
    borderRadius: borderRadius,
    imageColorId: imageColorId,
  );

  @override
  List<Object?> get props => [...super.props, color, opacity, thickness];
}

sealed class BaseWidgetSettings with SerializableMixin, EquatableMixin {
  @JsonKey(includeToJson: true)
  final WidgetType type;
  final WidgetDecoration decoration;

  final double horizontalPadding;
  final double verticalPadding;

  final double horizontalMargin;
  final double verticalMargin;

  const BaseWidgetSettings({
    required this.type,
    this.decoration = const NoDecoration(),
    this.horizontalPadding = 16,
    this.verticalPadding = 16,
    this.horizontalMargin = 56,
    this.verticalMargin = 56,
  });

  static BaseWidgetSettings fromJson(Map<String, dynamic> json) {
    final WidgetType type = json['type'] != null ? WidgetType.values.byName(json['type']) : WidgetType.none;
    switch (type) {
      case WidgetType.none:
        return NoneWidgetSettings();
      case WidgetType.digitalClock:
        return DigitalClockWidgetSettings.fromJson(json);
      case WidgetType.analogClock:
        return AnalogClockWidgetSettings.fromJson(json);
      case WidgetType.text:
        return MessageWidgetSettings.fromJson(json);
      case WidgetType.timer:
        return TimerWidgetSettings.fromJson(json);
      case WidgetType.weather:
        return WeatherWidgetSettings.fromJson(json);
      case WidgetType.digitalDate:
        return DigitalDateWidgetSettings.fromJson(json);
    }
  }

  BaseWidgetSettings copyWith({
    WidgetDecoration? decoration,
    double? horizontalPadding,
    double? verticalPadding,
    double? horizontalMargin,
    double? verticalMargin,
  });

  @override
  List<Object?> get props => [
    type,
    decoration,
    horizontalPadding,
    verticalPadding,
    horizontalMargin,
    verticalMargin,
  ];
}

@JsonSerializable()
final class NoneWidgetSettings extends BaseWidgetSettings {
  NoneWidgetSettings() : super(type: WidgetType.none);

  factory NoneWidgetSettings.fromJson(Map<String, dynamic> json) => _$NoneWidgetSettingsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NoneWidgetSettingsToJson(this);

  @override
  NoneWidgetSettings copyWith({
    WidgetDecoration? decoration,
    double? horizontalPadding,
    double? verticalPadding,
    double? horizontalMargin,
    double? verticalMargin,
  }) => NoneWidgetSettings();
}

@JsonSerializable()
final class DigitalClockWidgetSettings extends BaseWidgetSettings {
  final double fontSize;
  final Separator separator;
  final String fontFamily;
  final AlignmentC alignment;
  final ClockFormat format;

  const DigitalClockWidgetSettings({
    this.fontSize = 100,
    this.separator = Separator.colon,
    this.fontFamily = FontFamilies.product,
    this.alignment = AlignmentC.center,
    this.format = ClockFormat.twelveHour,
    super.decoration,
    super.horizontalMargin,
    super.verticalMargin,
    super.horizontalPadding,
    super.verticalPadding,
  }) : super(type: WidgetType.digitalClock);

  factory DigitalClockWidgetSettings.fromJson(Map<String, dynamic> json) => _$DigitalClockWidgetSettingsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DigitalClockWidgetSettingsToJson(this);

  @override
  DigitalClockWidgetSettings copyWith({
    double? fontSize,
    Separator? separator,
    String? fontFamily,
    AlignmentC? alignment,
    ClockFormat? format,
    double? horizontalMargin,
    double? verticalMargin,
    double? horizontalPadding,
    double? verticalPadding,
    WidgetDecoration? decoration,
  }) {
    return DigitalClockWidgetSettings(
      fontSize: fontSize ?? this.fontSize,
      separator: separator ?? this.separator,
      fontFamily: fontFamily ?? this.fontFamily,
      alignment: alignment ?? this.alignment,
      format: format ?? this.format,
      decoration: decoration ?? this.decoration,
      horizontalMargin: horizontalMargin ?? this.horizontalMargin,
      verticalMargin: verticalMargin ?? this.verticalMargin,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    fontSize,
    separator,
    fontFamily,
    alignment,
    format,
    type,
  ];
}

@JsonSerializable()
final class AnalogClockWidgetSettings extends BaseWidgetSettings {
  final double radius;
  final bool showSecondsHand;
  final bool coloredSecondHand;
  final AlignmentC alignment;

  const AnalogClockWidgetSettings({
    this.radius = 100,
    this.showSecondsHand = true,
    this.coloredSecondHand = false,
    this.alignment = AlignmentC.center,
    super.decoration,
    super.horizontalMargin,
    super.verticalMargin,
    super.horizontalPadding,
    super.verticalPadding,
  }) : super(type: WidgetType.analogClock);

  factory AnalogClockWidgetSettings.fromJson(Map<String, dynamic> json) => _$AnalogClockWidgetSettingsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AnalogClockWidgetSettingsToJson(this);

  @override
  AnalogClockWidgetSettings copyWith({
    double? radius,
    bool? showSecondsHand,
    bool? coloredSecondHand,
    AlignmentC? alignment,
    WidgetDecoration? decoration,
    double? horizontalMargin,
    double? verticalMargin,
    double? horizontalPadding,
    double? verticalPadding,
  }) {
    return AnalogClockWidgetSettings(
      radius: radius ?? this.radius,
      showSecondsHand: showSecondsHand ?? this.showSecondsHand,
      coloredSecondHand: coloredSecondHand ?? this.coloredSecondHand,
      alignment: alignment ?? this.alignment,
      decoration: decoration ?? this.decoration,
      horizontalMargin: horizontalMargin ?? this.horizontalMargin,
      verticalMargin: verticalMargin ?? this.verticalMargin,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    radius,
    showSecondsHand,
    coloredSecondHand,
    type,
    alignment,
  ];
}

@JsonSerializable()
final class MessageWidgetSettings extends BaseWidgetSettings {
  final double fontSize;
  final String fontFamily;
  final String message;
  final AlignmentC alignment;

  const MessageWidgetSettings({
    this.fontSize = 100,
    this.fontFamily = FontFamilies.product,
    this.message = 'Hello World!',
    this.alignment = AlignmentC.center,
    super.decoration,
    super.horizontalMargin,
    super.verticalMargin,
    super.horizontalPadding,
    super.verticalPadding,
  }) : super(type: WidgetType.text);

  factory MessageWidgetSettings.fromJson(Map<String, dynamic> json) => _$MessageWidgetSettingsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MessageWidgetSettingsToJson(this);

  @override
  MessageWidgetSettings copyWith({
    double? fontSize,
    String? fontFamily,
    String? message,
    AlignmentC? alignment,
    WidgetDecoration? decoration,
    double? horizontalMargin,
    double? verticalMargin,
    double? horizontalPadding,
    double? verticalPadding,
  }) {
    return MessageWidgetSettings(
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      message: message ?? this.message,
      alignment: alignment ?? this.alignment,
      decoration: decoration ?? this.decoration,
      horizontalMargin: horizontalMargin ?? this.horizontalMargin,
      verticalMargin: verticalMargin ?? this.verticalMargin,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    fontSize,
    fontFamily,
    message,
    type,
    alignment,
  ];
}

enum TimerFormat {
  seconds('Seconds'),
  minutes('minutes'),
  hours('Hours'),
  days('days'),
  years('Years'),
  descriptive('Descriptive'),
  descriptiveWithSeconds('Descriptive (with Seconds)'),
  countdown('Countdown')
  ;

  const TimerFormat(this.label);

  final String label;
}

@JsonSerializable()
final class TimerWidgetSettings extends BaseWidgetSettings {
  final double fontSize;
  final String fontFamily;
  final String textBefore;
  final String textAfter;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime time;
  final AlignmentC alignment;
  final TimerFormat format;

  TimerWidgetSettings({
    this.fontSize = 100,
    this.fontFamily = FontFamilies.product,
    this.textBefore = '',
    this.textAfter = '',
    DateTime? time,
    this.alignment = AlignmentC.center,
    this.format = TimerFormat.descriptive,
    super.decoration,
    super.horizontalMargin,
    super.verticalMargin,
    super.horizontalPadding,
    super.verticalPadding,
  }) : time = time ?? DateTime.now(),
       super(type: WidgetType.timer);

  factory TimerWidgetSettings.fromJson(Map<String, dynamic> json) => _$TimerWidgetSettingsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TimerWidgetSettingsToJson(this);

  @override
  TimerWidgetSettings copyWith({
    double? fontSize,
    String? fontFamily,
    String? textBefore,
    String? textAfter,
    DateTime? time,
    AlignmentC? alignment,
    TimerFormat? format,
    WidgetDecoration? decoration,
    double? horizontalMargin,
    double? verticalMargin,
    double? horizontalPadding,
    double? verticalPadding,
  }) {
    return TimerWidgetSettings(
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      textBefore: textBefore ?? this.textBefore,
      textAfter: textAfter ?? this.textAfter,
      time: time ?? this.time,
      alignment: alignment ?? this.alignment,
      format: format ?? this.format,
      decoration: decoration ?? this.decoration,
      horizontalMargin: horizontalMargin ?? this.horizontalMargin,
      verticalMargin: verticalMargin ?? this.verticalMargin,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    fontSize,
    fontFamily,
    textBefore,
    textAfter,
    time,
    type,
    alignment,
    format,
  ];
}

DateTime dateTimeFromJson(int millis) => DateTime.fromMillisecondsSinceEpoch(millis);

int dateTimeToJson(DateTime dateTime) => dateTime.millisecondsSinceEpoch;

enum WeatherFormat {
  temperature('Temperature'),
  temperatureAndSummary('Temperature and Summary')
  ;

  const WeatherFormat(this.label);

  final String label;
}

enum TemperatureUnit {
  celsius('Celsius'),
  fahrenheit('Fahrenheit')
  ;

  const TemperatureUnit(this.label);

  final String label;
}

@JsonSerializable()
final class WeatherWidgetSettings extends BaseWidgetSettings {
  final double fontSize;
  final String fontFamily;
  final AlignmentC alignment;
  final WeatherFormat format;
  final TemperatureUnit temperatureUnit;
  final Location location;

  WeatherWidgetSettings({
    this.fontSize = 100,
    this.fontFamily = FontFamilies.product,
    this.alignment = AlignmentC.center,
    this.format = WeatherFormat.temperatureAndSummary,
    this.temperatureUnit = TemperatureUnit.celsius,
    this.location = const Location(
      name: 'Tokyo',
      latitude: 35.6762,
      longitude: 139.6503,
      country: 'Japan',
      countryCode: 'JP',
    ),
    super.decoration,
    super.horizontalMargin,
    super.verticalMargin,
    super.horizontalPadding,
    super.verticalPadding,
  }) : super(type: WidgetType.weather);

  factory WeatherWidgetSettings.fromJson(Map<String, dynamic> json) => _$WeatherWidgetSettingsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WeatherWidgetSettingsToJson(this);

  @override
  WeatherWidgetSettings copyWith({
    double? fontSize,
    String? fontFamily,
    AlignmentC? alignment,
    WeatherFormat? format,
    TemperatureUnit? temperatureUnit,
    Location? location,
    WidgetDecoration? decoration,
    double? horizontalMargin,
    double? verticalMargin,
    double? horizontalPadding,
    double? verticalPadding,
  }) {
    return WeatherWidgetSettings(
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      alignment: alignment ?? this.alignment,
      format: format ?? this.format,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      location: location ?? this.location,
      decoration: decoration ?? this.decoration,
      horizontalMargin: horizontalMargin ?? this.horizontalMargin,
      verticalMargin: verticalMargin ?? this.verticalMargin,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    fontSize,
    fontFamily,
    type,
    alignment,
    format,
    temperatureUnit,
    location,
  ];
}

@JsonSerializable()
class Location with EquatableMixin {
  final double latitude;
  final double longitude;
  final String name;
  final String country;
  final String countryCode;

  const Location({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country = '',
    this.countryCode = '',
  });

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    name,
  ];

  Location copyWith({
    double? latitude,
    double? longitude,
    String? name,
    String? country,
    String? countryCode,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      name: name ?? this.name,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable()
final class DigitalDateWidgetSettings extends BaseWidgetSettings {
  final double fontSize;
  final DateSeparator separator;
  final String fontFamily;
  final AlignmentC alignment;
  final DateFormat format;
  final String customFormat;

  const DigitalDateWidgetSettings({
    this.fontSize = 100,
    this.separator = DateSeparator.slash,
    this.fontFamily = FontFamilies.product,
    this.alignment = AlignmentC.center,
    this.format = DateFormat.dayMonthYear,
    this.customFormat = 'MMMM dd, yyyy',
    super.decoration,
    super.horizontalMargin,
    super.verticalMargin,
    super.horizontalPadding,
    super.verticalPadding,
  }) : super(type: WidgetType.digitalDate);

  factory DigitalDateWidgetSettings.fromJson(Map<String, dynamic> json) => _$DigitalDateWidgetSettingsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DigitalDateWidgetSettingsToJson(this);

  @override
  DigitalDateWidgetSettings copyWith({
    double? fontSize,
    DateSeparator? separator,
    String? fontFamily,
    AlignmentC? alignment,
    DateFormat? format,
    WidgetDecoration? decoration,
    double? horizontalMargin,
    double? verticalMargin,
    double? horizontalPadding,
    double? verticalPadding,
  }) {
    return DigitalDateWidgetSettings(
      fontSize: fontSize ?? this.fontSize,
      separator: separator ?? this.separator,
      fontFamily: fontFamily ?? this.fontFamily,
      alignment: alignment ?? this.alignment,
      format: format ?? this.format,
      decoration: decoration ?? this.decoration,
      horizontalMargin: horizontalMargin ?? this.horizontalMargin,
      verticalMargin: verticalMargin ?? this.verticalMargin,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    fontSize,
    separator,
    fontFamily,
    alignment,
    format,
    type,
  ];
}
