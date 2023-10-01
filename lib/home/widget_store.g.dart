// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WidgetStore on _WidgetStore, Store {
  late final _$typeAtom = Atom(name: '_WidgetStore.type', context: context);

  @override
  WidgetType get type {
    _$typeAtom.reportRead();
    return super.type;
  }

  @override
  set type(WidgetType value) {
    _$typeAtom.reportWrite(value, super.type, () {
      super.type = value;
    });
  }

  late final _$initializedAtom =
      Atom(name: '_WidgetStore.initialized', context: context);

  @override
  bool get initialized {
    _$initializedAtom.reportRead();
    return super.initialized;
  }

  @override
  set initialized(bool value) {
    _$initializedAtom.reportWrite(value, super.initialized, () {
      super.initialized = value;
    });
  }

  late final _$reloadAsyncAction =
      AsyncAction('_WidgetStore.reload', context: context);

  @override
  Future<void> reload() {
    return _$reloadAsyncAction.run(() => super.reload());
  }

  late final _$resetAsyncAction =
      AsyncAction('_WidgetStore.reset', context: context);

  @override
  Future<void> reset() {
    return _$resetAsyncAction.run(() => super.reset());
  }

  late final _$_WidgetStoreActionController =
      ActionController(name: '_WidgetStore', context: context);

  @override
  void setType(WidgetType type) {
    final _$actionInfo = _$_WidgetStoreActionController.startAction(
        name: '_WidgetStore.setType');
    try {
      return super.setType(type);
    } finally {
      _$_WidgetStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
type: ${type},
initialized: ${initialized}
    ''';
  }
}

mixin _$DigitalClockWidgetSettingsStore
    on _DigitalClockWidgetSettingsStore, Store {
  late final _$fontSizeAtom =
      Atom(name: '_DigitalClockWidgetSettingsStore.fontSize', context: context);

  @override
  double get fontSize {
    _$fontSizeAtom.reportRead();
    return super.fontSize;
  }

  @override
  set fontSize(double value) {
    _$fontSizeAtom.reportWrite(value, super.fontSize, () {
      super.fontSize = value;
    });
  }

  late final _$separatorAtom = Atom(
      name: '_DigitalClockWidgetSettingsStore.separator', context: context);

  @override
  Separator get separator {
    _$separatorAtom.reportRead();
    return super.separator;
  }

  @override
  set separator(Separator value) {
    _$separatorAtom.reportWrite(value, super.separator, () {
      super.separator = value;
    });
  }

  late final _$borderTypeAtom = Atom(
      name: '_DigitalClockWidgetSettingsStore.borderType', context: context);

  @override
  BorderType get borderType {
    _$borderTypeAtom.reportRead();
    return super.borderType;
  }

  @override
  set borderType(BorderType value) {
    _$borderTypeAtom.reportWrite(value, super.borderType, () {
      super.borderType = value;
    });
  }

  late final _$fontFamilyAtom = Atom(
      name: '_DigitalClockWidgetSettingsStore.fontFamily', context: context);

  @override
  String get fontFamily {
    _$fontFamilyAtom.reportRead();
    return super.fontFamily;
  }

  @override
  set fontFamily(String value) {
    _$fontFamilyAtom.reportWrite(value, super.fontFamily, () {
      super.fontFamily = value;
    });
  }

  late final _$alignmentAtom = Atom(
      name: '_DigitalClockWidgetSettingsStore.alignment', context: context);

  @override
  AlignmentC get alignment {
    _$alignmentAtom.reportRead();
    return super.alignment;
  }

  @override
  set alignment(AlignmentC value) {
    _$alignmentAtom.reportWrite(value, super.alignment, () {
      super.alignment = value;
    });
  }

  late final _$formatAtom =
      Atom(name: '_DigitalClockWidgetSettingsStore.format', context: context);

  @override
  ClockFormat get format {
    _$formatAtom.reportRead();
    return super.format;
  }

  @override
  set format(ClockFormat value) {
    _$formatAtom.reportWrite(value, super.format, () {
      super.format = value;
    });
  }

  late final _$_DigitalClockWidgetSettingsStoreActionController =
      ActionController(
          name: '_DigitalClockWidgetSettingsStore', context: context);

  @override
  void update(VoidCallback callback, {bool save = true}) {
    final _$actionInfo = _$_DigitalClockWidgetSettingsStoreActionController
        .startAction(name: '_DigitalClockWidgetSettingsStore.update');
    try {
      return super.update(callback, save: save);
    } finally {
      _$_DigitalClockWidgetSettingsStoreActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setFrom(DigitalClockWidgetSettings? settings) {
    final _$actionInfo = _$_DigitalClockWidgetSettingsStoreActionController
        .startAction(name: '_DigitalClockWidgetSettingsStore.setFrom');
    try {
      return super.setFrom(settings);
    } finally {
      _$_DigitalClockWidgetSettingsStoreActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fontSize: ${fontSize},
separator: ${separator},
borderType: ${borderType},
fontFamily: ${fontFamily},
alignment: ${alignment},
format: ${format}
    ''';
  }
}

mixin _$AnalogClockWidgetSettingsStore
    on _AnalogClockWidgetSettingsStore, Store {
  late final _$radiusAtom =
      Atom(name: '_AnalogClockWidgetSettingsStore.radius', context: context);

  @override
  double get radius {
    _$radiusAtom.reportRead();
    return super.radius;
  }

  @override
  set radius(double value) {
    _$radiusAtom.reportWrite(value, super.radius, () {
      super.radius = value;
    });
  }

  late final _$showSecondsHandAtom = Atom(
      name: '_AnalogClockWidgetSettingsStore.showSecondsHand',
      context: context);

  @override
  bool get showSecondsHand {
    _$showSecondsHandAtom.reportRead();
    return super.showSecondsHand;
  }

  @override
  set showSecondsHand(bool value) {
    _$showSecondsHandAtom.reportWrite(value, super.showSecondsHand, () {
      super.showSecondsHand = value;
    });
  }

  late final _$coloredSecondHandAtom = Atom(
      name: '_AnalogClockWidgetSettingsStore.coloredSecondHand',
      context: context);

  @override
  bool get coloredSecondHand {
    _$coloredSecondHandAtom.reportRead();
    return super.coloredSecondHand;
  }

  @override
  set coloredSecondHand(bool value) {
    _$coloredSecondHandAtom.reportWrite(value, super.coloredSecondHand, () {
      super.coloredSecondHand = value;
    });
  }

  late final _$alignmentAtom =
      Atom(name: '_AnalogClockWidgetSettingsStore.alignment', context: context);

  @override
  AlignmentC get alignment {
    _$alignmentAtom.reportRead();
    return super.alignment;
  }

  @override
  set alignment(AlignmentC value) {
    _$alignmentAtom.reportWrite(value, super.alignment, () {
      super.alignment = value;
    });
  }

  late final _$_AnalogClockWidgetSettingsStoreActionController =
      ActionController(
          name: '_AnalogClockWidgetSettingsStore', context: context);

  @override
  void update(VoidCallback callback, {bool save = true}) {
    final _$actionInfo = _$_AnalogClockWidgetSettingsStoreActionController
        .startAction(name: '_AnalogClockWidgetSettingsStore.update');
    try {
      return super.update(callback, save: save);
    } finally {
      _$_AnalogClockWidgetSettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFrom(AnalogClockWidgetSettings? settings) {
    final _$actionInfo = _$_AnalogClockWidgetSettingsStoreActionController
        .startAction(name: '_AnalogClockWidgetSettingsStore.setFrom');
    try {
      return super.setFrom(settings);
    } finally {
      _$_AnalogClockWidgetSettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
radius: ${radius},
showSecondsHand: ${showSecondsHand},
coloredSecondHand: ${coloredSecondHand},
alignment: ${alignment}
    ''';
  }
}

mixin _$MessageWidgetSettingsStore on _MessageWidgetSettingsStore, Store {
  late final _$fontSizeAtom =
      Atom(name: '_MessageWidgetSettingsStore.fontSize', context: context);

  @override
  double get fontSize {
    _$fontSizeAtom.reportRead();
    return super.fontSize;
  }

  @override
  set fontSize(double value) {
    _$fontSizeAtom.reportWrite(value, super.fontSize, () {
      super.fontSize = value;
    });
  }

  late final _$fontFamilyAtom =
      Atom(name: '_MessageWidgetSettingsStore.fontFamily', context: context);

  @override
  String get fontFamily {
    _$fontFamilyAtom.reportRead();
    return super.fontFamily;
  }

  @override
  set fontFamily(String value) {
    _$fontFamilyAtom.reportWrite(value, super.fontFamily, () {
      super.fontFamily = value;
    });
  }

  late final _$messageAtom =
      Atom(name: '_MessageWidgetSettingsStore.message', context: context);

  @override
  String get message {
    _$messageAtom.reportRead();
    return super.message;
  }

  @override
  set message(String value) {
    _$messageAtom.reportWrite(value, super.message, () {
      super.message = value;
    });
  }

  late final _$alignmentAtom =
      Atom(name: '_MessageWidgetSettingsStore.alignment', context: context);

  @override
  AlignmentC get alignment {
    _$alignmentAtom.reportRead();
    return super.alignment;
  }

  @override
  set alignment(AlignmentC value) {
    _$alignmentAtom.reportWrite(value, super.alignment, () {
      super.alignment = value;
    });
  }

  late final _$_MessageWidgetSettingsStoreActionController =
      ActionController(name: '_MessageWidgetSettingsStore', context: context);

  @override
  void update(VoidCallback callback, {bool save = true}) {
    final _$actionInfo = _$_MessageWidgetSettingsStoreActionController
        .startAction(name: '_MessageWidgetSettingsStore.update');
    try {
      return super.update(callback, save: save);
    } finally {
      _$_MessageWidgetSettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFrom(MessageWidgetSettings? settings) {
    final _$actionInfo = _$_MessageWidgetSettingsStoreActionController
        .startAction(name: '_MessageWidgetSettingsStore.setFrom');
    try {
      return super.setFrom(settings);
    } finally {
      _$_MessageWidgetSettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fontSize: ${fontSize},
fontFamily: ${fontFamily},
message: ${message},
alignment: ${alignment}
    ''';
  }
}

mixin _$TimerWidgetSettingsStore on _TimerWidgetSettingsStore, Store {
  late final _$fontSizeAtom =
      Atom(name: '_TimerWidgetSettingsStore.fontSize', context: context);

  @override
  double get fontSize {
    _$fontSizeAtom.reportRead();
    return super.fontSize;
  }

  @override
  set fontSize(double value) {
    _$fontSizeAtom.reportWrite(value, super.fontSize, () {
      super.fontSize = value;
    });
  }

  late final _$fontFamilyAtom =
      Atom(name: '_TimerWidgetSettingsStore.fontFamily', context: context);

  @override
  String get fontFamily {
    _$fontFamilyAtom.reportRead();
    return super.fontFamily;
  }

  @override
  set fontFamily(String value) {
    _$fontFamilyAtom.reportWrite(value, super.fontFamily, () {
      super.fontFamily = value;
    });
  }

  late final _$textBeforeAtom =
      Atom(name: '_TimerWidgetSettingsStore.textBefore', context: context);

  @override
  String get textBefore {
    _$textBeforeAtom.reportRead();
    return super.textBefore;
  }

  @override
  set textBefore(String value) {
    _$textBeforeAtom.reportWrite(value, super.textBefore, () {
      super.textBefore = value;
    });
  }

  late final _$textAfterAtom =
      Atom(name: '_TimerWidgetSettingsStore.textAfter', context: context);

  @override
  String get textAfter {
    _$textAfterAtom.reportRead();
    return super.textAfter;
  }

  @override
  set textAfter(String value) {
    _$textAfterAtom.reportWrite(value, super.textAfter, () {
      super.textAfter = value;
    });
  }

  late final _$timeAtom =
      Atom(name: '_TimerWidgetSettingsStore.time', context: context);

  @override
  DateTime get time {
    _$timeAtom.reportRead();
    return super.time;
  }

  @override
  set time(DateTime value) {
    _$timeAtom.reportWrite(value, super.time, () {
      super.time = value;
    });
  }

  late final _$alignmentAtom =
      Atom(name: '_TimerWidgetSettingsStore.alignment', context: context);

  @override
  AlignmentC get alignment {
    _$alignmentAtom.reportRead();
    return super.alignment;
  }

  @override
  set alignment(AlignmentC value) {
    _$alignmentAtom.reportWrite(value, super.alignment, () {
      super.alignment = value;
    });
  }

  late final _$formatAtom =
      Atom(name: '_TimerWidgetSettingsStore.format', context: context);

  @override
  TimerFormat get format {
    _$formatAtom.reportRead();
    return super.format;
  }

  @override
  set format(TimerFormat value) {
    _$formatAtom.reportWrite(value, super.format, () {
      super.format = value;
    });
  }

  late final _$_TimerWidgetSettingsStoreActionController =
      ActionController(name: '_TimerWidgetSettingsStore', context: context);

  @override
  void update(VoidCallback callback, {bool save = true}) {
    final _$actionInfo = _$_TimerWidgetSettingsStoreActionController
        .startAction(name: '_TimerWidgetSettingsStore.update');
    try {
      return super.update(callback, save: save);
    } finally {
      _$_TimerWidgetSettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFrom(TimerWidgetSettings? settings) {
    final _$actionInfo = _$_TimerWidgetSettingsStoreActionController
        .startAction(name: '_TimerWidgetSettingsStore.setFrom');
    try {
      return super.setFrom(settings);
    } finally {
      _$_TimerWidgetSettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fontSize: ${fontSize},
fontFamily: ${fontFamily},
textBefore: ${textBefore},
textAfter: ${textAfter},
time: ${time},
alignment: ${alignment},
format: ${format}
    ''';
  }
}

mixin _$WeatherWidgetSettingsStore on _WeatherWidgetSettingsStore, Store {
  late final _$fontSizeAtom =
      Atom(name: '_WeatherWidgetSettingsStore.fontSize', context: context);

  @override
  double get fontSize {
    _$fontSizeAtom.reportRead();
    return super.fontSize;
  }

  @override
  set fontSize(double value) {
    _$fontSizeAtom.reportWrite(value, super.fontSize, () {
      super.fontSize = value;
    });
  }

  late final _$fontFamilyAtom =
      Atom(name: '_WeatherWidgetSettingsStore.fontFamily', context: context);

  @override
  String get fontFamily {
    _$fontFamilyAtom.reportRead();
    return super.fontFamily;
  }

  @override
  set fontFamily(String value) {
    _$fontFamilyAtom.reportWrite(value, super.fontFamily, () {
      super.fontFamily = value;
    });
  }

  late final _$alignmentAtom =
      Atom(name: '_WeatherWidgetSettingsStore.alignment', context: context);

  @override
  AlignmentC get alignment {
    _$alignmentAtom.reportRead();
    return super.alignment;
  }

  @override
  set alignment(AlignmentC value) {
    _$alignmentAtom.reportWrite(value, super.alignment, () {
      super.alignment = value;
    });
  }

  late final _$formatAtom =
      Atom(name: '_WeatherWidgetSettingsStore.format', context: context);

  @override
  WeatherFormat get format {
    _$formatAtom.reportRead();
    return super.format;
  }

  @override
  set format(WeatherFormat value) {
    _$formatAtom.reportWrite(value, super.format, () {
      super.format = value;
    });
  }

  late final _$temperatureUnitAtom = Atom(
      name: '_WeatherWidgetSettingsStore.temperatureUnit', context: context);

  @override
  TemperatureUnit get temperatureUnit {
    _$temperatureUnitAtom.reportRead();
    return super.temperatureUnit;
  }

  @override
  set temperatureUnit(TemperatureUnit value) {
    _$temperatureUnitAtom.reportWrite(value, super.temperatureUnit, () {
      super.temperatureUnit = value;
    });
  }

  late final _$locationAtom =
      Atom(name: '_WeatherWidgetSettingsStore.location', context: context);

  @override
  Location get location {
    _$locationAtom.reportRead();
    return super.location;
  }

  @override
  set location(Location value) {
    _$locationAtom.reportWrite(value, super.location, () {
      super.location = value;
    });
  }

  late final _$_WeatherWidgetSettingsStoreActionController =
      ActionController(name: '_WeatherWidgetSettingsStore', context: context);

  @override
  void update(VoidCallback callback, {bool save = true}) {
    final _$actionInfo = _$_WeatherWidgetSettingsStoreActionController
        .startAction(name: '_WeatherWidgetSettingsStore.update');
    try {
      return super.update(callback, save: save);
    } finally {
      _$_WeatherWidgetSettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFrom(WeatherWidgetSettings? settings) {
    final _$actionInfo = _$_WeatherWidgetSettingsStoreActionController
        .startAction(name: '_WeatherWidgetSettingsStore.setFrom');
    try {
      return super.setFrom(settings);
    } finally {
      _$_WeatherWidgetSettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fontSize: ${fontSize},
fontFamily: ${fontFamily},
alignment: ${alignment},
format: ${format},
temperatureUnit: ${temperatureUnit},
location: ${location}
    ''';
  }
}

mixin _$DigitalDateWidgetSettingsStore
    on _DigitalDateWidgetSettingsStore, Store {
  late final _$fontSizeAtom =
      Atom(name: '_DigitalDateWidgetSettingsStore.fontSize', context: context);

  @override
  double get fontSize {
    _$fontSizeAtom.reportRead();
    return super.fontSize;
  }

  @override
  set fontSize(double value) {
    _$fontSizeAtom.reportWrite(value, super.fontSize, () {
      super.fontSize = value;
    });
  }

  late final _$separatorAtom =
      Atom(name: '_DigitalDateWidgetSettingsStore.separator', context: context);

  @override
  DateSeparator get separator {
    _$separatorAtom.reportRead();
    return super.separator;
  }

  @override
  set separator(DateSeparator value) {
    _$separatorAtom.reportWrite(value, super.separator, () {
      super.separator = value;
    });
  }

  late final _$borderTypeAtom = Atom(
      name: '_DigitalDateWidgetSettingsStore.borderType', context: context);

  @override
  BorderType get borderType {
    _$borderTypeAtom.reportRead();
    return super.borderType;
  }

  @override
  set borderType(BorderType value) {
    _$borderTypeAtom.reportWrite(value, super.borderType, () {
      super.borderType = value;
    });
  }

  late final _$fontFamilyAtom = Atom(
      name: '_DigitalDateWidgetSettingsStore.fontFamily', context: context);

  @override
  String get fontFamily {
    _$fontFamilyAtom.reportRead();
    return super.fontFamily;
  }

  @override
  set fontFamily(String value) {
    _$fontFamilyAtom.reportWrite(value, super.fontFamily, () {
      super.fontFamily = value;
    });
  }

  late final _$alignmentAtom =
      Atom(name: '_DigitalDateWidgetSettingsStore.alignment', context: context);

  @override
  AlignmentC get alignment {
    _$alignmentAtom.reportRead();
    return super.alignment;
  }

  @override
  set alignment(AlignmentC value) {
    _$alignmentAtom.reportWrite(value, super.alignment, () {
      super.alignment = value;
    });
  }

  late final _$formatAtom =
      Atom(name: '_DigitalDateWidgetSettingsStore.format', context: context);

  @override
  DateFormat get format {
    _$formatAtom.reportRead();
    return super.format;
  }

  @override
  set format(DateFormat value) {
    _$formatAtom.reportWrite(value, super.format, () {
      super.format = value;
    });
  }

  late final _$_DigitalDateWidgetSettingsStoreActionController =
      ActionController(
          name: '_DigitalDateWidgetSettingsStore', context: context);

  @override
  void update(VoidCallback callback, {bool save = true}) {
    final _$actionInfo = _$_DigitalDateWidgetSettingsStoreActionController
        .startAction(name: '_DigitalDateWidgetSettingsStore.update');
    try {
      return super.update(callback, save: save);
    } finally {
      _$_DigitalDateWidgetSettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFrom(DigitalDateWidgetSettings? settings) {
    final _$actionInfo = _$_DigitalDateWidgetSettingsStoreActionController
        .startAction(name: '_DigitalDateWidgetSettingsStore.setFrom');
    try {
      return super.setFrom(settings);
    } finally {
      _$_DigitalDateWidgetSettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fontSize: ${fontSize},
separator: ${separator},
borderType: ${borderType},
fontFamily: ${fontFamily},
alignment: ${alignment},
format: ${format}
    ''';
  }
}
