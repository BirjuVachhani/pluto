import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../resources/fonts.dart';

part 'widget_settings.g.dart';

enum WidgetType {
  none('Nothing'),
  digitalClock('Digital Clock'),
  analogClock('Analog Clock'),
  text('Message'),
  timer('Timer'),
  weather('Weather'),
  digitalDate('Date & Time');
  // calendar('Calendar');

  const WidgetType(this.label);

  final String label;
}

enum BorderType { none, solid, rounded }

enum ClockFormat {
  twelveHour('12 Hours'),
  twelveHoursWithAmPm('12 Hours with AM / PM'),
  twentyFourHour('24 Hours');

  const ClockFormat(this.label);

  final String label;
}

enum DateFormat {
  dayMonthYear,
  monthDayYear,
  yearMonthDay,
  custom;

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
  newLine('\n');

  const Separator(this.value);

  final String value;
}

enum DateSeparator {
  dash('-'),
  dot('•'),
  slash('/');

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
  bottomRight('Bottom Right');

  const AlignmentC(this.label);

  final String label;
}

abstract class BaseWidgetSettings with EquatableMixin {
  abstract final WidgetType type;

  const BaseWidgetSettings();

  static BaseWidgetSettings fromJson(Map<String, dynamic> json) {
    final WidgetType type = json['type'] != null
        ? WidgetType.values.byName(json['type'])
        : WidgetType.none;
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

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class NoneWidgetSettings extends BaseWidgetSettings {
  @override
  final WidgetType type = WidgetType.digitalClock;

  NoneWidgetSettings();

  factory NoneWidgetSettings.fromJson(Map<String, dynamic> json) =>
      _$NoneWidgetSettingsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NoneWidgetSettingsToJson(this);

  @override
  List<Object?> get props => [type];
}

@JsonSerializable()
class DigitalClockWidgetSettings extends BaseWidgetSettings {
  final double fontSize;
  final Separator separator;
  final BorderType borderType;
  final String fontFamily;
  final AlignmentC alignment;
  final ClockFormat format;

  @override
  final WidgetType type = WidgetType.digitalClock;

  const DigitalClockWidgetSettings({
    this.fontSize = 100,
    this.separator = Separator.colon,
    this.borderType = BorderType.none,
    this.fontFamily = FontFamilies.product,
    this.alignment = AlignmentC.center,
    this.format = ClockFormat.twelveHour,
  });

  @override
  List<Object?> get props => [
        fontSize,
        separator,
        borderType,
        fontFamily,
        alignment,
        format,
        type,
      ];

  DigitalClockWidgetSettings copyWith({
    double? fontSize,
    Separator? separator,
    BorderType? borderType,
    String? fontFamily,
    AlignmentC? alignment,
    ClockFormat? format,
  }) {
    return DigitalClockWidgetSettings(
      fontSize: fontSize ?? this.fontSize,
      separator: separator ?? this.separator,
      borderType: borderType ?? this.borderType,
      fontFamily: fontFamily ?? this.fontFamily,
      alignment: alignment ?? this.alignment,
      format: format ?? this.format,
    );
  }

  factory DigitalClockWidgetSettings.fromJson(Map<String, dynamic> json) =>
      _$DigitalClockWidgetSettingsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DigitalClockWidgetSettingsToJson(this);
}

@JsonSerializable()
class AnalogClockWidgetSettings extends BaseWidgetSettings {
  final double radius;
  final bool showSecondsHand;
  final bool coloredSecondHand;
  final AlignmentC alignment;

  @override
  final WidgetType type = WidgetType.digitalClock;

  const AnalogClockWidgetSettings({
    this.radius = 100,
    this.showSecondsHand = true,
    this.coloredSecondHand = false,
    this.alignment = AlignmentC.center,
  });

  @override
  List<Object?> get props =>
      [radius, showSecondsHand, coloredSecondHand, type, alignment];

  AnalogClockWidgetSettings copyWith({
    double? radius,
    bool? showSecondsHand,
    bool? coloredSecondHand,
    AlignmentC? alignment,
  }) {
    return AnalogClockWidgetSettings(
      radius: radius ?? this.radius,
      showSecondsHand: showSecondsHand ?? this.showSecondsHand,
      coloredSecondHand: coloredSecondHand ?? this.coloredSecondHand,
      alignment: alignment ?? this.alignment,
    );
  }

  factory AnalogClockWidgetSettings.fromJson(Map<String, dynamic> json) =>
      _$AnalogClockWidgetSettingsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AnalogClockWidgetSettingsToJson(this);
}

@JsonSerializable()
class MessageWidgetSettings extends BaseWidgetSettings {
  final double fontSize;
  final String fontFamily;
  final String message;
  final AlignmentC alignment;

  @override
  final WidgetType type = WidgetType.text;

  const MessageWidgetSettings({
    this.fontSize = 100,
    this.fontFamily = FontFamilies.product,
    this.message = 'Hello World!',
    this.alignment = AlignmentC.center,
  });

  @override
  List<Object?> get props => [
        fontSize,
        fontFamily,
        message,
        type,
        alignment,
      ];

  MessageWidgetSettings copyWith({
    double? fontSize,
    String? fontFamily,
    String? message,
    AlignmentC? alignment,
  }) {
    return MessageWidgetSettings(
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      message: message ?? this.message,
      alignment: alignment ?? this.alignment,
    );
  }

  factory MessageWidgetSettings.fromJson(Map<String, dynamic> json) =>
      _$MessageWidgetSettingsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MessageWidgetSettingsToJson(this);
}

enum TimerFormat {
  seconds('Seconds'),
  minutes('minutes'),
  hours('Hours'),
  days('days'),
  years('Years'),
  descriptive('Descriptive'),
  descriptiveWithSeconds('Descriptive (with Seconds)'),
  countdown('Countdown');

  const TimerFormat(this.label);

  final String label;
}

@JsonSerializable()
class TimerWidgetSettings extends BaseWidgetSettings {
  final double fontSize;
  final String fontFamily;
  final String textBefore;
  final String textAfter;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime time;
  final AlignmentC alignment;
  final TimerFormat format;

  @override
  final WidgetType type = WidgetType.timer;

  TimerWidgetSettings({
    this.fontSize = 100,
    this.fontFamily = FontFamilies.product,
    this.textBefore = '',
    this.textAfter = '',
    DateTime? time,
    this.alignment = AlignmentC.center,
    this.format = TimerFormat.descriptive,
  }) : time = time ?? DateTime.now();

  @override
  List<Object?> get props => [
        fontSize,
        fontFamily,
        textBefore,
        textAfter,
        time,
        type,
        alignment,
        format,
      ];

  TimerWidgetSettings copyWith({
    double? fontSize,
    String? fontFamily,
    String? textBefore,
    String? textAfter,
    DateTime? time,
    AlignmentC? alignment,
    TimerFormat? format,
  }) {
    return TimerWidgetSettings(
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      textBefore: textBefore ?? this.textBefore,
      textAfter: textAfter ?? this.textAfter,
      time: time ?? this.time,
      alignment: alignment ?? this.alignment,
      format: format ?? this.format,
    );
  }

  factory TimerWidgetSettings.fromJson(Map<String, dynamic> json) =>
      _$TimerWidgetSettingsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TimerWidgetSettingsToJson(this);
}

DateTime dateTimeFromJson(int millis) =>
    DateTime.fromMillisecondsSinceEpoch(millis);

int dateTimeToJson(DateTime dateTime) => dateTime.millisecondsSinceEpoch;

enum WeatherFormat {
  temperature('Temperature'),
  temperatureAndSummary('Temperature and Summary');

  const WeatherFormat(this.label);

  final String label;
}

enum TemperatureUnit {
  celsius('Celsius'),
  fahrenheit('Fahrenheit');

  const TemperatureUnit(this.label);

  final String label;
}

@JsonSerializable()
class WeatherWidgetSettings extends BaseWidgetSettings {
  final double fontSize;
  final String fontFamily;
  final AlignmentC alignment;
  final WeatherFormat format;
  final TemperatureUnit temperatureUnit;
  final Location location;

  @override
  final WidgetType type = WidgetType.weather;

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
  });

  @override
  List<Object?> get props => [
        fontSize,
        fontFamily,
        type,
        alignment,
        format,
        temperatureUnit,
        location,
      ];

  WeatherWidgetSettings copyWith({
    double? fontSize,
    String? fontFamily,
    AlignmentC? alignment,
    WeatherFormat? format,
    TemperatureUnit? temperatureUnit,
    Location? location,
  }) {
    return WeatherWidgetSettings(
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      alignment: alignment ?? this.alignment,
      format: format ?? this.format,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      location: location ?? this.location,
    );
  }

  factory WeatherWidgetSettings.fromJson(Map<String, dynamic> json) =>
      _$WeatherWidgetSettingsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WeatherWidgetSettingsToJson(this);
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

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable()
class DigitalDateWidgetSettings extends BaseWidgetSettings {
  final double fontSize;
  final DateSeparator separator;
  final BorderType borderType;
  final String fontFamily;
  final AlignmentC alignment;
  final DateFormat format;
  final String customFormat;

  @override
  final WidgetType type = WidgetType.digitalDate;

  const DigitalDateWidgetSettings({
    this.fontSize = 100,
    this.separator = DateSeparator.slash,
    this.borderType = BorderType.none,
    this.fontFamily = FontFamilies.product,
    this.alignment = AlignmentC.center,
    this.format = DateFormat.dayMonthYear,
    this.customFormat = 'MMMM dd, yyyy',
  });

  @override
  List<Object?> get props => [
        fontSize,
        separator,
        borderType,
        fontFamily,
        alignment,
        format,
        type,
      ];

  DigitalDateWidgetSettings copyWith({
    double? fontSize,
    DateSeparator? separator,
    BorderType? borderType,
    String? fontFamily,
    AlignmentC? alignment,
    DateFormat? format,
  }) {
    return DigitalDateWidgetSettings(
      fontSize: fontSize ?? this.fontSize,
      separator: separator ?? this.separator,
      borderType: borderType ?? this.borderType,
      fontFamily: fontFamily ?? this.fontFamily,
      alignment: alignment ?? this.alignment,
      format: format ?? this.format,
    );
  }

  factory DigitalDateWidgetSettings.fromJson(Map<String, dynamic> json) =>
      _$DigitalDateWidgetSettingsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DigitalDateWidgetSettingsToJson(this);
}
