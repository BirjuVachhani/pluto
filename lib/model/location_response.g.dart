// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationResponse _$LocationResponseFromJson(Map<String, dynamic> json) => LocationResponse(
  name: json['name'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  country: json['country'] as String,
  countryCode: json['country_code'] as String,
  timezone: json['timezone'] as String,
  elevation: (json['elevation'] as num).toDouble(),
  description1: json['admin1'] as String?,
  description2: json['admin2'] as String?,
  description3: json['admin3'] as String?,
);

Map<String, dynamic> _$LocationResponseToJson(LocationResponse instance) => <String, dynamic>{
  'name': instance.name,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'country': instance.country,
  'country_code': instance.countryCode,
  'timezone': instance.timezone,
  'admin1': instance.description1,
  'admin2': instance.description2,
  'admin3': instance.description3,
  'elevation': instance.elevation,
};
