import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../model/widget_settings.dart';
import '../resources/storage_keys.dart';
import '../utils/storage_manager.dart';
import '../utils/utils.dart';

part 'widget_store.g.dart';

/// Interface for accessing common widget settings properties
/// shared across all widget types.
abstract class CommonWidgetSettingsAccessor {
  WidgetDecoration get decoration;

  set decoration(WidgetDecoration value);

  double get horizontalPadding;

  set horizontalPadding(double value);

  double get verticalPadding;

  set verticalPadding(double value);

  double get horizontalMargin;

  set horizontalMargin(double value);

  double get verticalMargin;

  set verticalMargin(double value);

  void update(VoidCallback callback, {bool save = true});
}

// ignore: library_private_types_in_public_api
class WidgetStore = _WidgetStore with _$WidgetStore;

abstract class _WidgetStore with Store, LazyInitializationMixin {
  late final LocalStorageManager storage = GetIt.instance.get<LocalStorageManager>();

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
  late DigitalDateWidgetSettingsStore digitalDateSettings;

  @override
  Future<void> init() async {
    type = await storage.getEnum<WidgetType>(StorageKeys.widgetType, WidgetType.values) ?? WidgetType.digitalClock;

    digitalClockSettings = DigitalClockWidgetSettingsStore(
      await storage.getSerializableObject<DigitalClockWidgetSettings>(
        StorageKeys.digitalClockSettings,
        DigitalClockWidgetSettings.fromJson,
      ),
    );

    analogueClockSettings = AnalogClockWidgetSettingsStore(
      await storage.getSerializableObject<AnalogClockWidgetSettings>(
        StorageKeys.analogueClockSettings,
        AnalogClockWidgetSettings.fromJson,
      ),
    );

    messageSettings = MessageWidgetSettingsStore(
      await storage.getSerializableObject<MessageWidgetSettings>(
        StorageKeys.messageSettings,
        MessageWidgetSettings.fromJson,
      ),
    );

    timerSettings = TimerWidgetSettingsStore(
      await storage.getSerializableObject<TimerWidgetSettings>(StorageKeys.timerSettings, TimerWidgetSettings.fromJson),
    );

    weatherSettings = WeatherWidgetSettingsStore(
      await storage.getSerializableObject<WeatherWidgetSettings>(
        StorageKeys.weatherSettings,
        WeatherWidgetSettings.fromJson,
      ),
    );

    digitalDateSettings = DigitalDateWidgetSettingsStore(
      await storage.getSerializableObject<DigitalDateWidgetSettings>(
        StorageKeys.digitalDateSettings,
        DigitalDateWidgetSettings.fromJson,
      ),
    );

    initialized = true;
  }

  @action
  Future<void> reload() async {
    type = await storage.getEnum<WidgetType>(StorageKeys.widgetType, WidgetType.values) ?? WidgetType.digitalClock;

    digitalClockSettings.setFrom(
      await storage.getSerializableObject<DigitalClockWidgetSettings>(
        StorageKeys.digitalClockSettings,
        DigitalClockWidgetSettings.fromJson,
      ),
    );

    analogueClockSettings.setFrom(
      await storage.getSerializableObject<AnalogClockWidgetSettings>(
        StorageKeys.analogueClockSettings,
        AnalogClockWidgetSettings.fromJson,
      ),
    );

    messageSettings.setFrom(
      await storage.getSerializableObject<MessageWidgetSettings>(
        StorageKeys.messageSettings,
        MessageWidgetSettings.fromJson,
      ),
    );

    timerSettings.setFrom(
      await storage.getSerializableObject<TimerWidgetSettings>(StorageKeys.timerSettings, TimerWidgetSettings.fromJson),
    );

    weatherSettings.setFrom(
      await storage.getSerializableObject<WeatherWidgetSettings>(
        StorageKeys.weatherSettings,
        WeatherWidgetSettings.fromJson,
      ),
    );

    digitalDateSettings.setFrom(
      await storage.getSerializableObject<DigitalDateWidgetSettings>(
        StorageKeys.digitalDateSettings,
        DigitalDateWidgetSettings.fromJson,
      ),
    );

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

  /// Called when background image palette colors change.
  /// Updates any widget decoration that has a bound [imageColorId].
  @action
  void syncDecorationColors(Map<String, Color> imageColors) {
    if (imageColors.isEmpty) return;
    for (final store in <CommonWidgetSettingsAccessor>[
      digitalClockSettings,
      analogueClockSettings,
      messageSettings,
      timerSettings,
      weatherSettings,
      digitalDateSettings,
    ]) {
      final id = store.decoration.imageColorId;
      if (id == null) continue;
      final newColor = imageColors[id];
      if (newColor == null) continue;
      store.update(() {
        store.decoration = store.decoration.withColor(newColor);
      });
    }
  }

  /// Returns the active widget settings store as a [CommonWidgetSettingsAccessor].
  CommonWidgetSettingsAccessor? get activeSettings {
    return switch (type) {
      WidgetType.none => null,
      WidgetType.digitalClock => digitalClockSettings,
      WidgetType.analogClock => analogueClockSettings,
      WidgetType.text => messageSettings,
      WidgetType.timer => timerSettings,
      WidgetType.weather => weatherSettings,
      WidgetType.digitalDate => digitalDateSettings,
    };
  }
}

// ignore: library_private_types_in_public_api
class DigitalClockWidgetSettingsStore = _DigitalClockWidgetSettingsStore with _$DigitalClockWidgetSettingsStore;

abstract class _DigitalClockWidgetSettingsStore with Store implements CommonWidgetSettingsAccessor {
  final DigitalClockWidgetSettings defaultSettings = const DigitalClockWidgetSettings();

  late final LocalStorageManager storage = GetIt.instance.get<LocalStorageManager>();

  @observable
  late double fontSize = defaultSettings.fontSize;
  @observable
  late Separator separator = defaultSettings.separator;
  @observable
  late String fontFamily = defaultSettings.fontFamily;
  @observable
  late AlignmentC alignment = defaultSettings.alignment;
  @observable
  late ClockFormat format = defaultSettings.format;
  @observable
  late WidgetDecoration decoration = defaultSettings.decoration;
  @observable
  late double horizontalPadding = defaultSettings.horizontalPadding;
  @observable
  late double verticalPadding = defaultSettings.verticalPadding;
  @observable
  late double horizontalMargin = defaultSettings.horizontalMargin;
  @observable
  late double verticalMargin = defaultSettings.verticalMargin;

  _DigitalClockWidgetSettingsStore(DigitalClockWidgetSettings? settings) {
    if (settings == null) return;
    fontSize = settings.fontSize;
    separator = settings.separator;
    fontFamily = settings.fontFamily;
    alignment = settings.alignment;
    format = settings.format;
    decoration = settings.decoration;
    horizontalPadding = settings.horizontalPadding;
    verticalPadding = settings.verticalPadding;
    horizontalMargin = settings.horizontalMargin;
    verticalMargin = settings.verticalMargin;
  }

  @action
  void update(VoidCallback callback, {bool save = true}) {
    callback();
    if (save) {
      final settings = getCurrentSettings();
      storage.setJson(StorageKeys.digitalClockSettings, settings.toJson());
    }
  }

  DigitalClockWidgetSettings getCurrentSettings() {
    return DigitalClockWidgetSettings(
      fontSize: fontSize,
      separator: separator,
      fontFamily: fontFamily,
      alignment: alignment,
      format: format,
      decoration: decoration,
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
      horizontalMargin: horizontalMargin,
      verticalMargin: verticalMargin,
    );
  }

  @action
  void setFrom(DigitalClockWidgetSettings? settings) {
    if (settings == null) return;
    fontSize = settings.fontSize;
    separator = settings.separator;
    fontFamily = settings.fontFamily;
    alignment = settings.alignment;
    format = settings.format;
    decoration = settings.decoration;
    horizontalPadding = settings.horizontalPadding;
    verticalPadding = settings.verticalPadding;
    horizontalMargin = settings.horizontalMargin;
    verticalMargin = settings.verticalMargin;
  }
}

// ignore: library_private_types_in_public_api
class AnalogClockWidgetSettingsStore = _AnalogClockWidgetSettingsStore with _$AnalogClockWidgetSettingsStore;

abstract class _AnalogClockWidgetSettingsStore with Store implements CommonWidgetSettingsAccessor {
  final AnalogClockWidgetSettings defaultSettings = const AnalogClockWidgetSettings();

  final LocalStorageManager storage = GetIt.instance.get<LocalStorageManager>();

  @observable
  late double radius = defaultSettings.radius;
  @observable
  late bool showSecondsHand = defaultSettings.showSecondsHand;
  @observable
  late bool coloredSecondHand = defaultSettings.coloredSecondHand;
  @observable
  late AlignmentC alignment = defaultSettings.alignment;
  @observable
  late WidgetDecoration decoration = defaultSettings.decoration;
  @observable
  late double horizontalPadding = defaultSettings.horizontalPadding;
  @observable
  late double verticalPadding = defaultSettings.verticalPadding;
  @observable
  late double horizontalMargin = defaultSettings.horizontalMargin;
  @observable
  late double verticalMargin = defaultSettings.verticalMargin;

  _AnalogClockWidgetSettingsStore(AnalogClockWidgetSettings? settings) {
    if (settings == null) return;
    radius = settings.radius;
    showSecondsHand = settings.showSecondsHand;
    coloredSecondHand = settings.coloredSecondHand;
    alignment = settings.alignment;
    decoration = settings.decoration;
    horizontalPadding = settings.horizontalPadding;
    verticalPadding = settings.verticalPadding;
    horizontalMargin = settings.horizontalMargin;
    verticalMargin = settings.verticalMargin;
  }

  @action
  void update(VoidCallback callback, {bool save = true}) {
    callback();
    if (save) {
      final settings = getCurrentSettings();
      storage.setJson(StorageKeys.analogueClockSettings, settings.toJson());
    }
  }

  AnalogClockWidgetSettings getCurrentSettings() {
    return AnalogClockWidgetSettings(
      radius: radius,
      showSecondsHand: showSecondsHand,
      coloredSecondHand: coloredSecondHand,
      alignment: alignment,
      decoration: decoration,
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
      horizontalMargin: horizontalMargin,
      verticalMargin: verticalMargin,
    );
  }

  @action
  void setFrom(AnalogClockWidgetSettings? settings) {
    if (settings == null) return;
    radius = settings.radius;
    showSecondsHand = settings.showSecondsHand;
    coloredSecondHand = settings.coloredSecondHand;
    alignment = settings.alignment;
    decoration = settings.decoration;
    horizontalPadding = settings.horizontalPadding;
    verticalPadding = settings.verticalPadding;
    horizontalMargin = settings.horizontalMargin;
    verticalMargin = settings.verticalMargin;
  }
}

// ignore: library_private_types_in_public_api
class MessageWidgetSettingsStore = _MessageWidgetSettingsStore with _$MessageWidgetSettingsStore;

abstract class _MessageWidgetSettingsStore with Store implements CommonWidgetSettingsAccessor {
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
  @observable
  late WidgetDecoration decoration = defaultSettings.decoration;
  @observable
  late double horizontalPadding = defaultSettings.horizontalPadding;
  @observable
  late double verticalPadding = defaultSettings.verticalPadding;
  @observable
  late double horizontalMargin = defaultSettings.horizontalMargin;
  @observable
  late double verticalMargin = defaultSettings.verticalMargin;

  _MessageWidgetSettingsStore(MessageWidgetSettings? settings) {
    if (settings == null) return;
    fontSize = settings.fontSize;
    fontFamily = settings.fontFamily;
    message = settings.message;
    alignment = settings.alignment;
    decoration = settings.decoration;
    horizontalPadding = settings.horizontalPadding;
    verticalPadding = settings.verticalPadding;
    horizontalMargin = settings.horizontalMargin;
    verticalMargin = settings.verticalMargin;
  }

  @action
  void update(VoidCallback callback, {bool save = true}) {
    callback();
    if (save) {
      final settings = getCurrentSettings();
      storage.setJson(StorageKeys.messageSettings, settings.toJson());
    }
  }

  MessageWidgetSettings getCurrentSettings() {
    return MessageWidgetSettings(
      fontSize: fontSize,
      fontFamily: fontFamily,
      message: message,
      alignment: alignment,
      decoration: decoration,
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
      horizontalMargin: horizontalMargin,
      verticalMargin: verticalMargin,
    );
  }

  @action
  void setFrom(MessageWidgetSettings? settings) {
    if (settings == null) return;
    fontSize = settings.fontSize;
    fontFamily = settings.fontFamily;
    message = settings.message;
    alignment = settings.alignment;
    decoration = settings.decoration;
    horizontalPadding = settings.horizontalPadding;
    verticalPadding = settings.verticalPadding;
    horizontalMargin = settings.horizontalMargin;
    verticalMargin = settings.verticalMargin;
  }
}

// ignore: library_private_types_in_public_api
class TimerWidgetSettingsStore = _TimerWidgetSettingsStore with _$TimerWidgetSettingsStore;

abstract class _TimerWidgetSettingsStore with Store implements CommonWidgetSettingsAccessor {
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
  @observable
  late WidgetDecoration decoration = defaultSettings.decoration;
  @observable
  late double horizontalPadding = defaultSettings.horizontalPadding;
  @observable
  late double verticalPadding = defaultSettings.verticalPadding;
  @observable
  late double horizontalMargin = defaultSettings.horizontalMargin;
  @observable
  late double verticalMargin = defaultSettings.verticalMargin;

  _TimerWidgetSettingsStore(TimerWidgetSettings? settings) {
    if (settings == null) return;
    fontSize = settings.fontSize;
    fontFamily = settings.fontFamily;
    textBefore = settings.textBefore;
    textAfter = settings.textAfter;
    time = settings.time;
    alignment = settings.alignment;
    format = settings.format;
    decoration = settings.decoration;
    horizontalPadding = settings.horizontalPadding;
    verticalPadding = settings.verticalPadding;
    horizontalMargin = settings.horizontalMargin;
    verticalMargin = settings.verticalMargin;
  }

  @action
  void update(VoidCallback callback, {bool save = true}) {
    callback();
    if (save) {
      final settings = getCurrentSettings();
      storage.setJson(StorageKeys.timerSettings, settings.toJson());
    }
  }

  TimerWidgetSettings getCurrentSettings() {
    return TimerWidgetSettings(
      fontSize: fontSize,
      fontFamily: fontFamily,
      textBefore: textBefore,
      textAfter: textAfter,
      time: time,
      alignment: alignment,
      format: format,
      decoration: decoration,
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
      horizontalMargin: horizontalMargin,
      verticalMargin: verticalMargin,
    );
  }

  @action
  void setFrom(TimerWidgetSettings? settings) {
    if (settings == null) return;
    fontSize = settings.fontSize;
    fontFamily = settings.fontFamily;
    textBefore = settings.textBefore;
    textAfter = settings.textAfter;
    time = settings.time;
    alignment = settings.alignment;
    format = settings.format;
    decoration = settings.decoration;
    horizontalPadding = settings.horizontalPadding;
    verticalPadding = settings.verticalPadding;
    horizontalMargin = settings.horizontalMargin;
    verticalMargin = settings.verticalMargin;
  }
}

// ignore: library_private_types_in_public_api
class WeatherWidgetSettingsStore = _WeatherWidgetSettingsStore with _$WeatherWidgetSettingsStore;

abstract class _WeatherWidgetSettingsStore with Store implements CommonWidgetSettingsAccessor {
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
  @observable
  late WidgetDecoration decoration = defaultSettings.decoration;
  @observable
  late double horizontalPadding = defaultSettings.horizontalPadding;
  @observable
  late double verticalPadding = defaultSettings.verticalPadding;
  @observable
  late double horizontalMargin = defaultSettings.horizontalMargin;
  @observable
  late double verticalMargin = defaultSettings.verticalMargin;

  _WeatherWidgetSettingsStore(WeatherWidgetSettings? settings) {
    if (settings == null) return;
    fontSize = settings.fontSize;
    fontFamily = settings.fontFamily;
    alignment = settings.alignment;
    format = settings.format;
    temperatureUnit = settings.temperatureUnit;
    location = settings.location;
    decoration = settings.decoration;
    horizontalPadding = settings.horizontalPadding;
    verticalPadding = settings.verticalPadding;
    horizontalMargin = settings.horizontalMargin;
    verticalMargin = settings.verticalMargin;
  }

  @action
  void update(VoidCallback callback, {bool save = true}) {
    callback();
    if (save) {
      final settings = getCurrentSettings();
      storage.setJson(StorageKeys.weatherSettings, settings.toJson());
    }
  }

  WeatherWidgetSettings getCurrentSettings() {
    return WeatherWidgetSettings(
      fontSize: fontSize,
      fontFamily: fontFamily,
      alignment: alignment,
      format: format,
      temperatureUnit: temperatureUnit,
      location: location,
      decoration: decoration,
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
      horizontalMargin: horizontalMargin,
      verticalMargin: verticalMargin,
    );
  }

  @action
  void setFrom(WeatherWidgetSettings? settings) {
    if (settings == null) return;
    fontSize = settings.fontSize;
    fontFamily = settings.fontFamily;
    alignment = settings.alignment;
    format = settings.format;
    temperatureUnit = settings.temperatureUnit;
    location = settings.location;
    decoration = settings.decoration;
    horizontalPadding = settings.horizontalPadding;
    verticalPadding = settings.verticalPadding;
    horizontalMargin = settings.horizontalMargin;
    verticalMargin = settings.verticalMargin;
  }
}

// ignore: library_private_types_in_public_api
class DigitalDateWidgetSettingsStore = _DigitalDateWidgetSettingsStore with _$DigitalDateWidgetSettingsStore;

abstract class _DigitalDateWidgetSettingsStore with Store implements CommonWidgetSettingsAccessor {
  final DigitalDateWidgetSettings defaultSettings = const DigitalDateWidgetSettings();

  late final LocalStorageManager storage = GetIt.instance.get<LocalStorageManager>();

  @observable
  late double fontSize = defaultSettings.fontSize;
  @observable
  late DateSeparator separator = defaultSettings.separator;
  @observable
  late String fontFamily = defaultSettings.fontFamily;
  @observable
  late AlignmentC alignment = defaultSettings.alignment;
  @observable
  late DateFormat format = defaultSettings.format;
  @observable
  late String customFormat = 'MMMM dd, yyyy';
  @observable
  late WidgetDecoration decoration = defaultSettings.decoration;
  @observable
  late double horizontalPadding = defaultSettings.horizontalPadding;
  @observable
  late double verticalPadding = defaultSettings.verticalPadding;
  @observable
  late double horizontalMargin = defaultSettings.horizontalMargin;
  @observable
  late double verticalMargin = defaultSettings.verticalMargin;

  _DigitalDateWidgetSettingsStore(DigitalDateWidgetSettings? settings) {
    if (settings == null) return;
    fontSize = settings.fontSize;
    separator = settings.separator;
    fontFamily = settings.fontFamily;
    alignment = settings.alignment;
    format = settings.format;
    customFormat = settings.customFormat;
    decoration = settings.decoration;
    horizontalPadding = settings.horizontalPadding;
    verticalPadding = settings.verticalPadding;
    horizontalMargin = settings.horizontalMargin;
    verticalMargin = settings.verticalMargin;
  }

  @action
  void update(VoidCallback callback, {bool save = true}) {
    callback();
    if (save) {
      final settings = getCurrentSettings();
      storage.setJson(StorageKeys.digitalDateSettings, settings.toJson());
    }
  }

  DigitalDateWidgetSettings getCurrentSettings() {
    return DigitalDateWidgetSettings(
      fontSize: fontSize,
      separator: separator,
      fontFamily: fontFamily,
      alignment: alignment,
      format: format,
      decoration: decoration,
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
      horizontalMargin: horizontalMargin,
      verticalMargin: verticalMargin,
    );
  }

  @action
  void setFrom(DigitalDateWidgetSettings? settings) {
    if (settings == null) return;
    fontSize = settings.fontSize;
    separator = settings.separator;
    fontFamily = settings.fontFamily;
    alignment = settings.alignment;
    format = settings.format;
    decoration = settings.decoration;
    horizontalPadding = settings.horizontalPadding;
    verticalPadding = settings.verticalPadding;
    horizontalMargin = settings.horizontalMargin;
    verticalMargin = settings.verticalMargin;
  }
}
