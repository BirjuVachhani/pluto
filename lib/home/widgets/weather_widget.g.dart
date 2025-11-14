// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_widget.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WeatherStore on _WeatherStore, Store {
  late final _$weatherInfoAtom = Atom(
    name: '_WeatherStore.weatherInfo',
    context: context,
  );

  @override
  WeatherInfo? get weatherInfo {
    _$weatherInfoAtom.reportRead();
    return super.weatherInfo;
  }

  @override
  set weatherInfo(WeatherInfo? value) {
    _$weatherInfoAtom.reportWrite(value, super.weatherInfo, () {
      super.weatherInfo = value;
    });
  }

  late final _$refetchWeatherAsyncAction = AsyncAction(
    '_WeatherStore.refetchWeather',
    context: context,
  );

  @override
  Future<void> refetchWeather() {
    return _$refetchWeatherAsyncAction.run(() => super.refetchWeather());
  }

  @override
  String toString() {
    return '''
weatherInfo: ${weatherInfo}
    ''';
  }
}
