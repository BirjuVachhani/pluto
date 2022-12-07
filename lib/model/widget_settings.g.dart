// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoneWidgetSettings _$NoneWidgetSettingsFromJson(Map<String, dynamic> json) =>
    NoneWidgetSettings();

Map<String, dynamic> _$NoneWidgetSettingsToJson(NoneWidgetSettings instance) =>
    <String, dynamic>{};

DigitalClockWidgetSettings _$DigitalClockWidgetSettingsFromJson(
        Map<String, dynamic> json) =>
    DigitalClockWidgetSettings(
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 100,
      separator: $enumDecodeNullable(_$SeparatorEnumMap, json['separator']) ??
          Separator.colon,
      borderType:
          $enumDecodeNullable(_$BorderTypeEnumMap, json['borderType']) ??
              BorderType.none,
      fontFamily: json['fontFamily'] as String? ?? FontFamilies.product,
      alignment: $enumDecodeNullable(_$AlignmentCEnumMap, json['alignment']) ??
          AlignmentC.center,
      format: $enumDecodeNullable(_$ClockFormatEnumMap, json['format']) ??
          ClockFormat.twelveHour,
    );

Map<String, dynamic> _$DigitalClockWidgetSettingsToJson(
        DigitalClockWidgetSettings instance) =>
    <String, dynamic>{
      'fontSize': instance.fontSize,
      'separator': _$SeparatorEnumMap[instance.separator]!,
      'borderType': _$BorderTypeEnumMap[instance.borderType]!,
      'fontFamily': instance.fontFamily,
      'alignment': _$AlignmentCEnumMap[instance.alignment]!,
      'format': _$ClockFormatEnumMap[instance.format]!,
    };

const _$SeparatorEnumMap = {
  Separator.nothing: 'none',
  Separator.dot: 'dot',
  Separator.colon: 'colon',
  Separator.dash: 'dash',
  Separator.space: 'space',
  Separator.newLine: 'newLine',
};

const _$BorderTypeEnumMap = {
  BorderType.none: 'none',
  BorderType.solid: 'solid',
  BorderType.rounded: 'rounded',
};

const _$AlignmentCEnumMap = {
  AlignmentC.topLeft: 'topLeft',
  AlignmentC.topCenter: 'topCenter',
  AlignmentC.topRight: 'topRight',
  AlignmentC.centerLeft: 'centerLeft',
  AlignmentC.center: 'center',
  AlignmentC.centerRight: 'centerRight',
  AlignmentC.bottomLeft: 'bottomLeft',
  AlignmentC.bottomCenter: 'bottomCenter',
  AlignmentC.bottomRight: 'bottomRight',
};

const _$ClockFormatEnumMap = {
  ClockFormat.twelveHour: 'twelveHour',
  ClockFormat.twentyFourHour: 'twentyFourHour',
};

AnalogClockWidgetSettings _$AnalogClockWidgetSettingsFromJson(
        Map<String, dynamic> json) =>
    AnalogClockWidgetSettings(
      radius: (json['radius'] as num?)?.toDouble() ?? 100,
      showSecondsHand: json['showSecondsHand'] as bool? ?? true,
      coloredSecondHand: json['coloredSecondHand'] as bool? ?? false,
      alignment: $enumDecodeNullable(_$AlignmentCEnumMap, json['alignment']) ??
          AlignmentC.center,
    );

Map<String, dynamic> _$AnalogClockWidgetSettingsToJson(
        AnalogClockWidgetSettings instance) =>
    <String, dynamic>{
      'radius': instance.radius,
      'showSecondsHand': instance.showSecondsHand,
      'coloredSecondHand': instance.coloredSecondHand,
      'alignment': _$AlignmentCEnumMap[instance.alignment]!,
    };

MessageWidgetSettings _$MessageWidgetSettingsFromJson(
        Map<String, dynamic> json) =>
    MessageWidgetSettings(
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 100,
      fontFamily: json['fontFamily'] as String? ?? FontFamilies.product,
      message: json['message'] as String? ?? 'Hello World!',
      alignment: $enumDecodeNullable(_$AlignmentCEnumMap, json['alignment']) ??
          AlignmentC.center,
    );

Map<String, dynamic> _$MessageWidgetSettingsToJson(
        MessageWidgetSettings instance) =>
    <String, dynamic>{
      'fontSize': instance.fontSize,
      'fontFamily': instance.fontFamily,
      'message': instance.message,
      'alignment': _$AlignmentCEnumMap[instance.alignment]!,
    };

TimerWidgetSettings _$TimerWidgetSettingsFromJson(Map<String, dynamic> json) =>
    TimerWidgetSettings(
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 100,
      fontFamily: json['fontFamily'] as String? ?? FontFamilies.product,
      textBefore: json['textBefore'] as String? ?? '',
      textAfter: json['textAfter'] as String? ?? '',
      time: dateTimeFromJson(json['time'] as int),
      alignment: $enumDecodeNullable(_$AlignmentCEnumMap, json['alignment']) ??
          AlignmentC.center,
      format: $enumDecodeNullable(_$TimerFormatEnumMap, json['format']) ??
          TimerFormat.descriptive,
    );

Map<String, dynamic> _$TimerWidgetSettingsToJson(
        TimerWidgetSettings instance) =>
    <String, dynamic>{
      'fontSize': instance.fontSize,
      'fontFamily': instance.fontFamily,
      'textBefore': instance.textBefore,
      'textAfter': instance.textAfter,
      'time': dateTimeToJson(instance.time),
      'alignment': _$AlignmentCEnumMap[instance.alignment]!,
      'format': _$TimerFormatEnumMap[instance.format]!,
    };

const _$TimerFormatEnumMap = {
  TimerFormat.seconds: 'seconds',
  TimerFormat.minutes: 'minutes',
  TimerFormat.hours: 'hours',
  TimerFormat.days: 'days',
  TimerFormat.years: 'years',
  TimerFormat.descriptive: 'descriptive',
  TimerFormat.countdown: 'countdown',
};
