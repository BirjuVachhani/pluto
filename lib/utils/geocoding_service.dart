import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../model/location_response.dart';

abstract class GeocodingService {
  Future<List<LocationResponse>> fetchLocations(String query);
}

/// Uses Open-Meteo's open source geocoding API.
/// Docs: https://open-meteo.com/en/docs/geocoding-api
class OpenMeteoGeocodingService implements GeocodingService {
  final String _baseUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  @override
  Future<List<LocationResponse>> fetchLocations(String query) async {
    try {
      final uri = Uri.parse('$_baseUrl?name=$query');
      final response = await http.get(uri);
      log(uri.toString());

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        final locations =
            List<Map<String, dynamic>>.from(decodedJson['results'] ?? []);
        return locations
            .map((item) => LocationResponse.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load locations');
      }
    } catch (error, stacktrace) {
      log(error.toString());
      log(stacktrace.toString());
      throw Exception('Failed to load locations');
    }
  }
}
