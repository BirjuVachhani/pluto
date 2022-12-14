import 'dart:ui';

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../model/widget_settings.dart';
import '../resources/storage_keys.dart';
import '../utils/storage_manager.dart';
import '../utils/utils.dart';

part 'widget_store.g.dart';

// ignore: library_private_types_in_public_api
class WidgetStore = _WidgetStore with _$WidgetStore;

abstract class _WidgetStore with Store, LazyInitializationMixin {
  late final LocalStorageManager storage =
      GetIt.instance.get<LocalStorageManager>();

  _WidgetStore() {
    init();
  }

  @observable
  WidgetType type = WidgetType.none;

  @observable
  bool initialized = false;

  late DigitalClockWidgetSettingsStore digitalClockSettings;
  late AnalogClockWidgetSettingsStore analogueClockSettings;
  late MessageWidgetSettingsStore messageSettings;
  late TimerWidgetSettingsStore timerSettings;
  late WeatherWidgetSettingsStore weatherSettings;

  @override
  Future<void> init() async {
    type = await storage.getEnum<WidgetType>(
            StorageKeys.widgetType, WidgetType.values) ??
        WidgetType.digitalClock;

    digitalClockSettings = DigitalClockWidgetSettingsStore(
        await storage.getSerializableObject<DigitalClockWidgetSettings>(
            StorageKeys.digitalClockSettings,
            DigitalClockWidgetSettings.fromJson));

    analogueClockSettings = AnalogClockWidgetSettingsStore(
        await storage.getSerializableObject<AnalogClockWidgetSettings>(
            StorageKeys.analogueClockSettings,
            AnalogClockWidgetSettings.fromJson));

    messageSettings = MessageWidgetSettingsStore(
        await storage.getSerializableObject<MessageWidgetSettings>(
            StorageKeys.messageSettings, MessageWidgetSettings.fromJson));

    timerSettings = TimerWidgetSettingsStore(
        await storage.getSerializableObject<TimerWidgetSettings>(
            StorageKeys.timerSettings, TimerWidgetSettings.fromJson));

    weatherSettings = WeatherWidgetSettingsStore(
        await storage.getSerializableObject<WeatherWidgetSettings>(
            StorageKeys.weatherSettings, WeatherWidgetSettings.fromJson));

    initialized = true;
  }

  @action
  void setType(WidgetType type) {
    this.type = type;
    storage.setEnum(StorageKeys.widgetType, type);
  }

  @action
  Future<void> reset() async {
    initialized = false;
    await init();
  }
}

// ignore: library_private_types_in_public_api
class DigitalClockWidgetSettingsStore = _DigitalClockWidgetSettingsStore
    with _$DigitalClockWidgetSettingsStore;

abstract class _DigitalClockWidgetSettingsStore with Store {
  final DigitalClockWidgetSettings defaultSettings =
      const DigitalClockWidgetSettings();

  late final LocalStorageManager storage =
      GetIt.instance.get<LocalStorageManager>();

  @observable
  late double fontSize = defaultSettings.fontSize;
  @observable
  late Separator separator = defaultSettings.separator;
  @observable
  late BorderType borderType = defaultSettings.borderType;
  @observable
  late String fontFamily = defaultSettings.fontFamily;
  @observable
  late AlignmentC alignment = defaultSettings.alignment;
  @observable
  late ClockFormat format = defaultSettings.format;

  _DigitalClockWidgetSettingsStore(DigitalClockWidgetSettings? settings) {
    if (settings == null) return;
    fontSize = settings.fontSize;
    separator = settings.separator;
    borderType = settings.borderType;
    fontFamily = settings.fontFamily;
    alignment = settings.alignment;
    format = settings.format;
  }

  @action
  void update(VoidCallback callback, {bool save = true}) {
    callback();
    if (save) {
      final settings = DigitalClockWidgetSettings(
        fontSize: fontSize,
        separator: separator,
        borderType: borderType,
        fontFamily: fontFamily,
        alignment: alignment,
        format: format,
      );
      storage.setJson(StorageKeys.digitalClockSettings, settings.toJson());
    }
  }
}

// ignore: library_private_types_in_public_api
class AnalogClockWidgetSettingsStore = _AnalogClockWidgetSettingsStore
    with _$AnalogClockWidgetSettingsStore;

abstract class _AnalogClockWidgetSettingsStore with Store {
  final AnalogClockWidgetSettings defaultSettings =
      const AnalogClockWidgetSettings();

  final LocalStorageManager storage = GetIt.instance.get<LocalStorageManager>();

  @observable
  late double radius = defaultSettings.radius;
  @observable
  late bool showSecondsHand = defaultSettings.showSecondsHand;
  @observable
  late bool coloredSecondHand = defaultSettings.coloredSecondHand;
  @observable
  late AlignmentC alignment = defaultSettings.alignment;

  _AnalogClockWidgetSettingsStore(AnalogClockWidgetSettings? settings) {
    if (settings == null) return;
    radius = settings.radius;
    showSecondsHand = settings.showSecondsHand;
    coloredSecondHand = settings.coloredSecondHand;
    alignment = settings.alignment;
  }

  @action
  void update(VoidCallback callback, {bool save = true}) {
    callback();
    if (save) {
      final settings = AnalogClockWidgetSettings(
        radius: radius,
        showSecondsHand: showSecondsHand,
        coloredSecondHand: coloredSecondHand,
        alignment: alignment,
      );
      storage.setJson(StorageKeys.analogueClockSettings, settings.toJson());
    }
  }
}

// ignore: library_private_types_in_public_api
class MessageWidgetSettingsStore = _MessageWidgetSettingsStore
    with _$MessageWidgetSettingsStore;

abstract class _MessageWidgetSettingsStore with Store {
  final MessageWidgetSettings defaultSettings = const MessageWidgetSettings();

  final LocalStorageManager storage = GetIt.instance.get<LocalStorageManager>();

  @observable
  late double fontSize = defaultSettings.fontSize;
  @observable
  late String fontFamily = defaultSettings.fontFamily;
  @observable
  late String message = defaultSettings.message;
  @observable
  late AlignmentC alignment = defaultSettings.alignment;

  _MessageWidgetSettingsStore(MessageWidgetSettings? settings) {
    if (settings == null) return;
    fontSize = settings.fontSize;
    fontFamily = settings.fontFamily;
    message = settings.message;
    alignment = settings.alignment;
  }

  @action
  void update(VoidCallback callback, {bool save = true}) {
    callback();
    if (save) {
      final settings = MessageWidgetSettings(
        fontSize: fontSize,
        fontFamily: fontFamily,
        message: message,
        alignment: alignment,
      );
      storage.setJson(StorageKeys.messageSettings, settings.toJson());
    }
  }
}

// ignore: library_private_types_in_public_api
class TimerWidgetSettingsStore = _TimerWidgetSettingsStore
    with _$TimerWidgetSettingsStore;

abstract class _TimerWidgetSettingsStore with Store {
  final TimerWidgetSettings defaultSettings = TimerWidgetSettings(
    fontSize: 24,
    textBefore: 'It has been ',
    textAfter: ' since man first landed on the moon.',
    time: DateTime(1969, 7, 20, 20, 17),
    alignment: AlignmentC.center,
    format: TimerFormat.descriptive,
  );

  final LocalStorageManager storage = GetIt.instance.get<LocalStorageManager>();

  @observable
  late double fontSize = defaultSettings.fontSize;
  @observable
  late String fontFamily = defaultSettings.fontFamily;
  @observable
  late String textBefore = defaultSettings.textBefore;
  @observable
  late String textAfter = defaultSettings.textAfter;
  @observable
  late DateTime time = defaultSettings.time;
  @observable
  late AlignmentC alignment = defaultSettings.alignment;
  @observable
  late TimerFormat format = defaultSettings.format;

  _TimerWidgetSettingsStore(TimerWidgetSettings? settings) {
    if (settings == null) return;
    fontSize = settings.fontSize;
    fontFamily = settings.fontFamily;
    textBefore = settings.textBefore;
    textAfter = settings.textAfter;
    time = settings.time;
    alignment = settings.alignment;
    format = settings.format;
  }

  @action
  void update(VoidCallback callback, {bool save = true}) {
    callback();
    if (save) {
      final settings = TimerWidgetSettings(
        fontSize: fontSize,
        fontFamily: fontFamily,
        textBefore: textBefore,
        textAfter: textAfter,
        time: time,
        alignment: alignment,
        format: format,
      );
      storage.setJson(StorageKeys.timerSettings, settings.toJson());
    }
  }
}

// ignore: library_private_types_in_public_api
class WeatherWidgetSettingsStore = _WeatherWidgetSettingsStore
    with _$WeatherWidgetSettingsStore;

abstract class _WeatherWidgetSettingsStore with Store {
  final WeatherWidgetSettings defaultSettings = WeatherWidgetSettings();

  final LocalStorageManager storage = GetIt.instance.get<LocalStorageManager>();

  @observable
  late double fontSize = defaultSettings.fontSize;
  @observable
  late String fontFamily = defaultSettings.fontFamily;
  @observable
  late AlignmentC alignment = defaultSettings.alignment;
  @observable
  late WeatherFormat format = defaultSettings.format;
  @observable
  late TemperatureUnit temperatureUnit = defaultSettings.temperatureUnit;
  @observable
  late Location location = defaultSettings.location;

  _WeatherWidgetSettingsStore(WeatherWidgetSettings? settings) {
    if (settings == null) return;
    fontSize = settings.fontSize;
    fontFamily = settings.fontFamily;
    alignment = settings.alignment;
    format = settings.format;
    temperatureUnit = settings.temperatureUnit;
    location = settings.location;
  }

  @action
  void update(VoidCallback callback, {bool save = true}) {
    callback();
    if (save) {
      final settings = WeatherWidgetSettings(
        fontSize: fontSize,
        fontFamily: fontFamily,
        alignment: alignment,
        format: format,
        temperatureUnit: temperatureUnit,
        location: location,
      );
      storage.setJson(StorageKeys.weatherSettings, settings.toJson());
    }
  }
}
