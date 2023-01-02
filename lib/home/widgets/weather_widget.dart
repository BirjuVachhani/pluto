import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../model/weather_info.dart';
import '../../model/widget_settings.dart';
import '../../resources/storage_keys.dart';
import '../../utils/custom_observer.dart';
import '../../utils/extensions.dart';
import '../../utils/storage_manager.dart';
import '../../utils/utils.dart';
import '../../utils/weather_service.dart';
import '../background_store.dart';
import '../widget_store.dart';

part 'weather_widget.g.dart';

/// Duration between weather updates.
const Duration weatherUpdateDuration = Duration(minutes: 30);

// ignore: library_private_types_in_public_api
class WeatherStore = _WeatherStore with _$WeatherStore;

abstract class _WeatherStore with Store, LazyInitializationMixin {
  @observable
  WeatherInfo? weatherInfo;

  bool isLoadingWeather = false;
  bool initialized = false;

  final double latitude;
  final double longitude;

  late final LocalStorageManager storage =
      GetIt.instance.get<LocalStorageManager>();

  late final WeatherService weatherService =
      GetIt.instance.get<WeatherService>();

  DateTime? weatherLastUpdated;

  _WeatherStore(this.latitude, this.longitude) {
    init();
  }

  @override
  Future<void> init() async {
    weatherInfo = await storage.getSerializableObject<WeatherInfo>(
        StorageKeys.weatherInfo, WeatherInfo.fromJson);

    // load image last updated time
    weatherLastUpdated =
        await storage.getInt(StorageKeys.weatherLastUpdated).then((value) {
      if (value == null) return DateTime.now();
      return DateTime.fromMillisecondsSinceEpoch(value);
    });

    /// Whether the weather info is outdated and needs to be updated.
    final bool isExpired =
        weatherLastUpdated!.add(weatherUpdateDuration).isBefore(DateTime.now());

    /// Whether the weather info is outdated and needs to be updated. This
    /// would be the case if the user has changed their location from settings
    /// and the weather info is still for the old location.
    final bool locationChanged = weatherInfo != null &&
        (weatherInfo!.latitude != latitude ||
            weatherInfo!.longitude != longitude);

    if (locationChanged) {
      log('cached location: ${weatherInfo?.latitude}, ${weatherInfo?.longitude}');
      log('current location: $latitude, $longitude');
    }

    // re-fetch weather info if expired or location changed or weather info is null.
    if (weatherInfo == null || isExpired || locationChanged) {
      weatherInfo = null;
      log('Immediately fetching weather info');
      refetchWeather();
    }

    initialized = true;
  }

  /// Refreshes the background image on timer callback.
  void onTimerCallback() async {
    final DateTime? weatherLastUpdated = this.weatherLastUpdated;
    if (weatherLastUpdated == null) return;
    // log('Auto weather refresh has been triggered');

    // Exit if it is not time to update weather.
    if (weatherLastUpdated.add(weatherUpdateDuration).isAfter(DateTime.now()) ||
        isLoadingWeather) {
      // Enable this to see the remaining time in console.

      // final remainingTime = weatherLastUpdated
      //     .add(weatherUpdateDuration)
      //     .difference(DateTime.now());
      // log('Next weather update in ${remainingTime.inSeconds} seconds');
      return;
    }

    this.weatherLastUpdated = DateTime.now();

    // Update the background image.
    storage.setInt(StorageKeys.weatherLastUpdated,
        this.weatherLastUpdated!.millisecondsSinceEpoch);

    // Log next background change time.
    _logNextWeatherUpdate();

    await refetchWeather();
  }

  @action
  Future<void> refetchWeather() async {
    return fetchWeather().then((value) {
      if (value == null) return;
      weatherInfo = value;

      // save weather info
      storage.setJson(StorageKeys.weatherInfo, value.toJson());

      // save last updated time
      weatherLastUpdated = DateTime.now();
      storage.setInt(StorageKeys.weatherLastUpdated,
          weatherLastUpdated!.millisecondsSinceEpoch);
    });
  }

  /// Logs the next background change time.
  void _logNextWeatherUpdate() {
    final DateTime? weatherLastUpdated = this.weatherLastUpdated;
    if (weatherLastUpdated == null) return;

    final nextUpdateTime = weatherLastUpdated.add(weatherUpdateDuration);

    // ignore: avoid_print
    print('Next weather update at $nextUpdateTime');
  }

  Future<WeatherInfo?> fetchWeather() async {
    isLoadingWeather = true;
    try {
      log('Updating weather for location $latitude, $longitude');
      final info = await weatherService.fetchWeather(latitude, longitude);
      isLoadingWeather = false;
      return info;
    } catch (error, stacktrace) {
      log(error.toString());
      log(stacktrace.toString());
      isLoadingWeather = false;
      return null;
    }
  }
}

class WeatherWidgetWrapper extends StatelessWidget {
  final double latitude;
  final double longitude;

  const WeatherWidgetWrapper({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Provider<WeatherStore>(
      create: (context) => WeatherStore(latitude, longitude),
      child: const WeatherWidget(),
    );
  }
}

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget>
    with SingleTickerProviderStateMixin {
  Timer? _timer;

  late final WeatherStore store = context.read<WeatherStore>();

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
        const Duration(seconds: 1), (timer) => store.onTimerCallback());
  }

  @override
  Widget build(BuildContext context) {
    final BackgroundStore backgroundStore = context.read<BackgroundStore>();
    final settings = context.read<WidgetStore>().weatherSettings;

    return CustomObserver(
      name: 'WeatherWidget',
      builder: (context) {
        return Align(
          alignment: settings.alignment.flutterAlignment,
          child: Padding(
            padding: const EdgeInsets.all(56),
            child: FittedBox(
              child: Text(
                buildText(store.weatherInfo, settings),
                textAlign: settings.alignment.textAlign,
                style: TextStyle(
                  color: backgroundStore.foregroundColor,
                  fontSize: settings.fontSize,
                  fontFamily: settings.fontFamily,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String buildText(
    WeatherInfo? weatherInfo,
    WeatherWidgetSettingsStore settings,
  ) {
    if (weatherInfo == null) return '_ _';
    final String temperature;
    if (settings.temperatureUnit == TemperatureUnit.celsius) {
      temperature = '${weatherInfo.temperature.round()}°';
    } else {
      temperature = '${(weatherInfo.temperature * 9 / 5 + 32).round()}°';
    }
    switch (settings.format) {
      case WeatherFormat.temperature:
        return temperature;
      case WeatherFormat.temperatureAndSummary:
        return '$temperature ${weatherInfo.weatherCode.label}';
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
