import 'package:json_annotation/json_annotation.dart';

part 'weather_response.g.dart';

@JsonSerializable()
class OpenMeteoWeatherResponse {
  final double latitude;
  final double longitude;
  @JsonKey(name: 'utc_offset_seconds')
  final int utcOffsetSeconds;
  final String timezone;
  @JsonKey(name: 'timezone_abbreviation')
  final String timezoneAbbr;
  final double elevation;
  @JsonKey(name: 'current_weather')
  final CurrentWeatherData currentWeather;

  OpenMeteoWeatherResponse({
    required this.latitude,
    required this.longitude,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbr,
    required this.elevation,
    required this.currentWeather,
  });

  factory OpenMeteoWeatherResponse.fromJson(Map<String, dynamic> json) =>
      _$OpenMeteoWeatherResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OpenMeteoWeatherResponseToJson(this);
}

@JsonSerializable()
class CurrentWeatherData {
  final double temperature;
  @JsonKey(name: 'windspeed')
  final double windSpeed;
  @JsonKey(name: 'winddirection')
  final double windDirection;
  @JsonKey(name: 'weathercode')
  final int weatherCode;
  @JsonKey(fromJson: timeFromJson, toJson: timeToJson)
  final DateTime time;

  CurrentWeatherData({
    required this.temperature,
    required this.windSpeed,
    required this.windDirection,
    required this.weatherCode,
    required this.time,
  });

  static DateTime timeFromJson(String time) => DateTime.parse(time);

  static String timeToJson(DateTime time) => time.toIso8601String();

  factory CurrentWeatherData.fromJson(Map<String, dynamic> json) =>
      _$CurrentWeatherDataFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentWeatherDataToJson(this);
}
