import 'package:json_annotation/json_annotation.dart';

import 'widget_settings.dart';

part 'location_response.g.dart';

@JsonSerializable()
class LocationResponse {
  final String name;
  final double latitude;
  final double longitude;
  final String country;
  @JsonKey(name: 'country_code')
  final String countryCode;
  final String timezone;
  @JsonKey(name: 'admin1')
  final String? description1;
  @JsonKey(name: 'admin2')
  final String? description2;
  @JsonKey(name: 'admin3')
  final String? description3;
  final double elevation;

  const LocationResponse({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.countryCode,
    required this.timezone,
    required this.elevation,
    this.description1,
    this.description2,
    this.description3,
  });

  factory LocationResponse.fromJson(Map<String, dynamic> json) =>
      _$LocationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LocationResponseToJson(this);

  Location toLocation() {
    return Location(
      name: name,
      latitude: latitude,
      longitude: longitude,
      country: country,
      countryCode: countryCode,
    );
  }
}
