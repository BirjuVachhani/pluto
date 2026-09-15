// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExportData _$ExportDataFromJson(Map<String, dynamic> json) => ExportData(
  settings: BackgroundSettings.fromJson(
    json['settings'] as Map<String, dynamic>,
  ),
  image1: json['image1'] == null ? null : Background.fromJson(json['image1'] as Map<String, dynamic>),
  image2: json['image2'] == null ? null : Background.fromJson(json['image2'] as Map<String, dynamic>),
  likedBackgrounds: (json['likedBackgrounds'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, LikedBackground.fromJson(e as Map<String, dynamic>)),
  ),
  createdAt: dateTimeFromJson((json['createdAt'] as num).toInt()),
  version: (json['version'] as num).toInt(),
  imageIndex: (json['imageIndex'] as num).toInt(),
  image1Time: dateTimeFromJson((json['image1Time'] as num).toInt()),
  image2Time: dateTimeFromJson((json['image2Time'] as num).toInt()),
  widgetSettings: WidgetsExportData.fromJson(
    json['widgetSettings'] as Map<String, dynamic>,
  ),
  imageDownloadQuality:
      $enumDecodeNullable(
        _$ImageResolutionEnumMap,
        json['imageDownloadQuality'],
      ) ??
      ImageResolution.auto,
);

Map<String, dynamic> _$ExportDataToJson(ExportData instance) => <String, dynamic>{
  'settings': instance.settings,
  'image1': instance.image1,
  'image2': instance.image2,
  'imageIndex': instance.imageIndex,
  'likedBackgrounds': instance.likedBackgrounds,
  'createdAt': dateTimeToJson(instance.createdAt),
  'image1Time': dateTimeToJson(instance.image1Time),
  'image2Time': dateTimeToJson(instance.image2Time),
  'version': instance.version,
  'widgetSettings': instance.widgetSettings,
  'imageDownloadQuality': _$ImageResolutionEnumMap[instance.imageDownloadQuality]!,
};

const _$ImageResolutionEnumMap = {
  ImageResolution.auto: 'auto',
  ImageResolution.original: 'original',
  ImageResolution.hd: 'hd',
  ImageResolution.fullHd: 'fullHd',
  ImageResolution.quadHD: 'quadHD',
  ImageResolution.ultraHD: 'ultraHD',
  ImageResolution.fiveK: 'fiveK',
  ImageResolution.eightK: 'eightK',
};

WidgetsExportData _$WidgetsExportDataFromJson(Map<String, dynamic> json) => WidgetsExportData(
  type: $enumDecode(_$WidgetTypeEnumMap, json['type']),
  analogClock: AnalogClockWidgetSettings.fromJson(
    json['analogClock'] as Map<String, dynamic>,
  ),
  digitalClock: DigitalClockWidgetSettings.fromJson(
    json['digitalClock'] as Map<String, dynamic>,
  ),
  timer: TimerWidgetSettings.fromJson(
    json['timer'] as Map<String, dynamic>,
  ),
  message: MessageWidgetSettings.fromJson(
    json['message'] as Map<String, dynamic>,
  ),
  weather: WeatherWidgetSettings.fromJson(
    json['weather'] as Map<String, dynamic>,
  ),
  digitalDate: DigitalDateWidgetSettings.fromJson(
    json['digitalDate'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$WidgetsExportDataToJson(WidgetsExportData instance) => <String, dynamic>{
  'type': _$WidgetTypeEnumMap[instance.type]!,
  'analogClock': instance.analogClock,
  'digitalClock': instance.digitalClock,
  'timer': instance.timer,
  'message': instance.message,
  'weather': instance.weather,
  'digitalDate': instance.digitalDate,
};

const _$WidgetTypeEnumMap = {
  WidgetType.none: 'none',
  WidgetType.digitalClock: 'digitalClock',
  WidgetType.analogClock: 'analogClock',
  WidgetType.text: 'text',
  WidgetType.timer: 'timer',
  WidgetType.weather: 'weather',
  WidgetType.digitalDate: 'digitalDate',
};
