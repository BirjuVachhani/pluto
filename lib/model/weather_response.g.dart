// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenMeteoWeatherResponse _$OpenMeteoWeatherResponseFromJson(
        Map<String, dynamic> json) =>
    OpenMeteoWeatherResponse(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      utcOffsetSeconds: (json['utc_offset_seconds'] as num).toInt(),
      timezone: json['timezone'] as String,
      timezoneAbbr: json['timezone_abbreviation'] as String,
      elevation: (json['elevation'] as num).toDouble(),
      currentWeather: CurrentWeatherData.fromJson(
          json['current_weather'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OpenMeteoWeatherResponseToJson(
        OpenMeteoWeatherResponse instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'utc_offset_seconds': instance.utcOffsetSeconds,
      'timezone': instance.timezone,
      'timezone_abbreviation': instance.timezoneAbbr,
      'elevation': instance.elevation,
      'current_weather': instance.currentWeather,
    };

CurrentWeatherData _$CurrentWeatherDataFromJson(Map<String, dynamic> json) =>
    CurrentWeatherData(
      temperature: (json['temperature'] as num).toDouble(),
      windSpeed: (json['windspeed'] as num).toDouble(),
      windDirection: (json['winddirection'] as num).toDouble(),
      weatherCode: (json['weathercode'] as num).toInt(),
      time: CurrentWeatherData.timeFromJson(json['time'] as String),
    );

Map<String, dynamic> _$CurrentWeatherDataToJson(CurrentWeatherData instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'windspeed': instance.windSpeed,
      'winddirection': instance.windDirection,
      'weathercode': instance.weatherCode,
      'time': CurrentWeatherData.timeToJson(instance.time),
    };
