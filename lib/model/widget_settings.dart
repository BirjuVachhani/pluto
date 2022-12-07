import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../resources/fonts.dart';

part 'widget_settings.g.dart';

enum WidgetType {
  none('Nothing'),
  digitalClock('Digital Clock'),
  analogClock('Analog Clock'),
  text('Message'),
  timer('Timer');
  // weather('Weather'),
  // calendar('Calendar'),
  // location('Location');

  const WidgetType(this.label);

  final String label;
}

enum BorderType { none, solid, rounded }

enum ClockFormat {
  twelveHour('12 Hours'),
  twentyFourHour('24 Hours');

  const ClockFormat(this.label);

  final String label;
}

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
        return const NoneWidgetSettings();
      case WidgetType.digitalClock:
        return DigitalClockWidgetSettings.fromJson(json);
      case WidgetType.analogClock:
        return AnalogClockWidgetSettings.fromJson(json);
      case WidgetType.text:
        return MessageWidgetSettings.fromJson(json);
      case WidgetType.timer:
        return TimerWidgetSettings();
    }
  }

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class NoneWidgetSettings extends BaseWidgetSettings {
  @override
  final WidgetType type = WidgetType.digitalClock;

  const NoneWidgetSettings();

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
