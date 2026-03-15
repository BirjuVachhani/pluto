// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherInfo _$WeatherInfoFromJson(Map<String, dynamic> json) => WeatherInfo(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  temperature: (json['temperature'] as num).toDouble(),
  weatherCode: $enumDecode(_$WeatherCodeEnumMap, json['weatherCode']),
  timestamp: dateTimeFromJson((json['timestamp'] as num).toInt()),
);

Map<String, dynamic> _$WeatherInfoToJson(WeatherInfo instance) => <String, dynamic>{
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'temperature': instance.temperature,
  'weatherCode': _$WeatherCodeEnumMap[instance.weatherCode]!,
  'timestamp': dateTimeToJson(instance.timestamp),
};

const _$WeatherCodeEnumMap = {
  WeatherCode.unknown: 'unknown',
  WeatherCode.clearSky: 'clearSky',
  WeatherCode.mainlyClear: 'mainlyClear',
  WeatherCode.partlyCloudy: 'partlyCloudy',
  WeatherCode.cloudy: 'cloudy',
  WeatherCode.haze: 'haze',
  WeatherCode.fog: 'fog',
  WeatherCode.depositingRimeFog: 'depositingRimeFog',
  WeatherCode.lightDrizzle: 'lightDrizzle',
  WeatherCode.moderateDrizzle: 'moderateDrizzle',
  WeatherCode.heavyDrizzle: 'heavyDrizzle',
  WeatherCode.lightFreezingDrizzle: 'lightFreezingDrizzle',
  WeatherCode.heavyFreezingDrizzle: 'heavyFreezingDrizzle',
  WeatherCode.slightRain: 'slightRain',
  WeatherCode.moderateRain: 'moderateRain',
  WeatherCode.heavyRain: 'heavyRain',
  WeatherCode.lightFreezingRain: 'lightFreezingRain',
  WeatherCode.heavyFreezingRain: 'heavyFreezingRain',
  WeatherCode.slightSnowFall: 'slightSnowFall',
  WeatherCode.moderateSnowFall: 'moderateSnowFall',
  WeatherCode.heavySnowFall: 'heavySnowFall',
  WeatherCode.snowGrains: 'snowGrains',
  WeatherCode.slightRainShowers: 'slightRainShowers',
  WeatherCode.moderateRainShowers: 'moderateRainShowers',
  WeatherCode.violentRainShowers: 'violentRainShowers',
  WeatherCode.slightSnowShowers: 'slightSnowShowers',
  WeatherCode.heavySnowShowers: 'heavySnowShowers',
  WeatherCode.thunderstorm: 'thunderstorm',
  WeatherCode.thunderstormWithSlightHail: 'thunderstormWithSlightHail',
  WeatherCode.thunderstormWithHeavyHail: 'thunderstormWithHeavyHail',
};
