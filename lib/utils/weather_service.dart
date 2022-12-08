import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../model/weather_info.dart';
import '../model/weather_response.dart';

abstract class WeatherService {
  Future<WeatherInfo?> fetchWeather(double latitude, double longitude);
}

/// Uses Open-Meteo's open source weather API.
/// Docs: https://open-meteo.com/en/docs
class OpenMeteoWeatherService extends WeatherService {
  @override
  Future<WeatherInfo?> fetchWeather(double latitude, double longitude) async {
    try {
      final url =
          'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true&timezone=auto';
      log('url: $url');
      final result = await http.get(Uri.parse(url));
      if (result.statusCode == 200) {
        final json = jsonDecode(result.body);
        final response = OpenMeteoWeatherResponse.fromJson(json);
        return WeatherInfo(
          latitude: latitude,
          longitude: longitude,
          temperature: response.currentWeather.temperature,
          timestamp: response.currentWeather.time,
          weatherCode:
              WeatherCode.fromCode(response.currentWeather.weatherCode),
        );
      } else {
        log('status code: ${result.statusCode}');
        log('response: ${result.body}');
        return null;
      }
    } catch (error, stacktrace) {
      log(error.toString());
      log(stacktrace.toString());
      throw Exception('Failed to load weather');
    }
  }
}
