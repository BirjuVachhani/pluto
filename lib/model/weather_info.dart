import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'widget_settings.dart';

part 'weather_info.g.dart';

/// Weather codes defined by WMO: World Meteorological Organization
enum WeatherCode {
  unknown(-1, 'Unknown'),
  clearSky(0, 'Clear sky'),
  mainlyClear(1, 'Mainly clear'),
  partlyCloudy(2, 'Partly cloudy'),
  cloudy(3, 'Overcast'),
  haze(4, 'Haze'),
  fog(45, 'Fog'),
  depositingRimeFog(46, 'Depositing rime fog'),
  lightDrizzle(51, 'Light drizzle'),
  moderateDrizzle(53, 'Moderate drizzle'),
  heavyDrizzle(55, 'Heavy drizzle'),
  lightFreezingDrizzle(56, 'Light freezing drizzle'),
  heavyFreezingDrizzle(57, 'Heavy freezing drizzle'),
  slightRain(61, 'Slight rain'),
  moderateRain(63, 'Moderate rain'),
  heavyRain(65, 'Heavy rain'),
  lightFreezingRain(66, 'Light freezing rain'),
  heavyFreezingRain(67, 'Heavy freezing rain'),
  slightSnowFall(71, 'Slight snowfall'),
  moderateSnowFall(73, 'Moderate snowfall'),
  heavySnowFall(75, 'Heavy snowfall'),
  snowGrains(77, 'Snow grains'),
  slightRainShowers(80, 'Slight rain showers'),
  moderateRainShowers(81, 'Moderate rain showers'),
  violentRainShowers(82, 'Violent rain showers'),
  slightSnowShowers(85, 'Slight snow showers'),
  heavySnowShowers(86, 'Heavy snow showers'),
  thunderstorm(95, 'Thunderstorm'),
  thunderstormWithSlightHail(96, 'Thunderstorm with slight hail'),
  thunderstormWithHeavyHail(99, 'Thunderstorm with heavy hail');

  const WeatherCode(this.code, this.label);

  final String label;
  final int code;

  factory WeatherCode.fromCode(int code) {
    return WeatherCode.values.firstWhereOrNull((item) => item.code == code) ??
        WeatherCode.unknown;
  }
}

@JsonSerializable()
class WeatherInfo with EquatableMixin {
  final double latitude;
  final double longitude;
  final double temperature;
  final WeatherCode weatherCode;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime timestamp;

  WeatherInfo({
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.weatherCode,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        temperature,
        weatherCode,
        timestamp,
      ];

  WeatherInfo copyWith({
    double? latitude,
    double? longitude,
    double? temperature,
    WeatherCode? weatherCode,
    DateTime? timestamp,
  }) {
    return WeatherInfo(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      temperature: temperature ?? this.temperature,
      weatherCode: weatherCode ?? this.weatherCode,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory WeatherInfo.fromJson(Map<String, dynamic> json) =>
      _$WeatherInfoFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherInfoToJson(this);
}
