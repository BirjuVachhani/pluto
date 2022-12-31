import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../model/widget_settings.dart';
import '../resources/storage_keys.dart';
import '../utils/storage_manager.dart';
import '../utils/utils.dart';
import 'widgets/analog_clock_widget.dart';
import 'widgets/digital_clock_widget.dart';
import 'widgets/message_widget.dart';
import 'widgets/timer_widget.dart';
import 'widgets/weather_widget.dart';

abstract class WidgetModelBase with ChangeNotifier, LazyInitializationMixin {
  WidgetType type = WidgetType.none;
  bool initialized = false;

  late DigitalClockWidgetSettings digitalClockSettings;
  late AnalogClockWidgetSettings analogueClockSettings;
  late MessageWidgetSettings messageSettings;
  late TimerWidgetSettings timerSettings;
  late WeatherWidgetSettings weatherSettings;

  void setType(WidgetType type);

  void updateDigitalClockSettings(DigitalClockWidgetSettings settings);

  void updateAnalogClockSettings(AnalogClockWidgetSettings settings);

  void updateMessageSettings(MessageWidgetSettings settings,
      {bool save = true});

  void updateTimerSettings(TimerWidgetSettings settings, {bool save = true});

  void updateWeatherSettings(WeatherWidgetSettings settings,
      {bool save = true});

  Future<void> reset();
}

class WidgetModel extends WidgetModelBase {
  late final LocalStorageManager storage =
      GetIt.instance.get<LocalStorageManager>();

  @override
  Future<void> init() async {
    type = await storage.getEnum<WidgetType>(
            StorageKeys.widgetType, WidgetType.values) ??
        WidgetType.digitalClock;

    digitalClockSettings =
        await storage.getSerializableObject<DigitalClockWidgetSettings>(
                StorageKeys.digitalClockSettings,
                DigitalClockWidgetSettings.fromJson) ??
            const DigitalClockWidgetSettings();

    analogueClockSettings =
        await storage.getSerializableObject<AnalogClockWidgetSettings>(
                StorageKeys.analogueClockSettings,
                AnalogClockWidgetSettings.fromJson) ??
            const AnalogClockWidgetSettings();

    messageSettings =
        await storage.getSerializableObject<MessageWidgetSettings>(
                StorageKeys.messageSettings, MessageWidgetSettings.fromJson) ??
            const MessageWidgetSettings();

    timerSettings = await storage.getSerializableObject<TimerWidgetSettings>(
            StorageKeys.timerSettings, TimerWidgetSettings.fromJson) ??
        TimerWidgetSettings(
          fontSize: 24,
          textBefore: 'It has been ',
          textAfter: ' since man first landed on the moon.',
          time: DateTime(1969, 7, 20, 20, 17),
          alignment: AlignmentC.center,
          format: TimerFormat.descriptive,
        );

    weatherSettings =
        await storage.getSerializableObject<WeatherWidgetSettings>(
                StorageKeys.weatherSettings, WeatherWidgetSettings.fromJson) ??
            WeatherWidgetSettings();

    initialized = true;
    notifyListeners();
  }

  @override
  void setType(WidgetType type) {
    this.type = type;
    storage.setEnum(StorageKeys.widgetType, type);
    notifyListeners();
  }

  @override
  void updateDigitalClockSettings(DigitalClockWidgetSettings settings) {
    digitalClockSettings = settings;
    storage.setJson(StorageKeys.digitalClockSettings, settings.toJson());
    notifyListeners();
  }

  @override
  void updateAnalogClockSettings(AnalogClockWidgetSettings settings) {
    analogueClockSettings = settings;
    storage.setJson(StorageKeys.analogueClockSettings, settings.toJson());
    notifyListeners();
  }

  @override
  void updateMessageSettings(MessageWidgetSettings settings,
      {bool save = true}) {
    messageSettings = settings;
    if (save) storage.setJson(StorageKeys.messageSettings, settings.toJson());
    notifyListeners();
  }

  @override
  void updateTimerSettings(TimerWidgetSettings settings, {bool save = true}) {
    timerSettings = settings;
    if (save) storage.setJson(StorageKeys.timerSettings, settings.toJson());
    notifyListeners();
  }

  @override
  void updateWeatherSettings(WeatherWidgetSettings settings,
      {bool save = true}) {
    weatherSettings = settings;
    if (save) storage.setJson(StorageKeys.weatherSettings, settings.toJson());
    notifyListeners();
  }

  @override
  Future<void> reset() async {
    initialized = false;
    notifyListeners();
    await init();
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WidgetModelBase>(
      builder: (context, model, child) {
        if (!model.initialized) return const SizedBox.shrink();
        switch (model.type) {
          case WidgetType.none:
            return const SizedBox.shrink();
          case WidgetType.digitalClock:
            return const DigitalClockWidget();
          case WidgetType.analogClock:
            return const AnalogClockWidget();
          case WidgetType.text:
            return const MessageWidget();
          case WidgetType.timer:
            return const TimerWidget();
          case WidgetType.weather:
            final latitude = model.weatherSettings.location.latitude;
            final longitude = model.weatherSettings.location.longitude;
            return WeatherWidgetWrapper(
              key: ValueKey('$latitude, $longitude'),
              latitude: latitude,
              longitude: longitude,
            );
        }
      },
    );
  }
}
