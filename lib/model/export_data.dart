import 'package:json_annotation/json_annotation.dart';
import 'package:screwdriver/screwdriver.dart';

import 'background_settings.dart';
import 'widget_settings.dart';

part 'export_data.g.dart';

@JsonSerializable()
class ExportData with SerializableMixin {
  final BackgroundSettings settings;
  final Background? image1;
  final Background? image2;
  final int imageIndex;
  final Map<String, LikedBackground> likedBackgrounds;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime createdAt;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime image1Time;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime image2Time;
  final int version;
  final WidgetsExportData widgetSettings;
  final ImageResolution imageDownloadQuality;

  ExportData({
    required this.settings,
    this.image1,
    this.image2,
    required this.likedBackgrounds,
    required this.createdAt,
    required this.version,
    required this.imageIndex,
    required this.image1Time,
    required this.image2Time,
    required this.widgetSettings,
    this.imageDownloadQuality = ImageResolution.auto,
  });

  @override
  JsonMap toJson() => _$ExportDataToJson(this);

  factory ExportData.fromJson(JsonMap json) => _$ExportDataFromJson(json);
}

@JsonSerializable()
class WidgetsExportData with SerializableMixin {
  final WidgetType type;
  final AnalogClockWidgetSettings analogClock;
  final DigitalClockWidgetSettings digitalClock;
  final TimerWidgetSettings timer;
  final MessageWidgetSettings message;
  final WeatherWidgetSettings weather;
  final DigitalDateWidgetSettings digitalDate;

  WidgetsExportData({
    required this.type,
    required this.analogClock,
    required this.digitalClock,
    required this.timer,
    required this.message,
    required this.weather,
    required this.digitalDate,
  });

  factory WidgetsExportData.fromJson(JsonMap json) => _$WidgetsExportDataFromJson(json);

  @override
  JsonMap toJson() => _$WidgetsExportDataToJson(this);
}
