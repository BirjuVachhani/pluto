import 'dart:convert';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:screwdriver/screwdriver.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_io/io.dart' as io;

import '../model/export_data.dart';
import '../model/widget_settings.dart';
import '../resources/storage_keys.dart';
import '../ui/message_banner/message_banner.dart';
import '../utils/storage_manager.dart';
import '../utils/utils.dart';
import 'background_store.dart';

part 'home_store.g.dart';

// ignore: library_private_types_in_public_api
class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store, LazyInitializationMixin {
  late final MessageBannerController messageBannerController =
      MessageBannerController();

  _HomeStore() {
    init();
  }

  @readonly
  bool _isPanelVisible = false;

  @readonly
  bool _initialized = false;

  @readonly
  int _currentTabIndex = 0;

  TabController? tabController;

  @override
  Future<void> init() async {
    // Initialize stuff
    _initialized = true;
  }

  @action
  void showPanel() {
    _isPanelVisible = true;
  }

  @action
  void hidePanel() {
    _isPanelVisible = false;
    _currentTabIndex = 0;
  }

  @action
  Future<void> reset() async {
    _isPanelVisible = false;
    _initialized = false;
    _currentTabIndex = 0;
    await init();
  }

  @action
  void setTabIndex(int index) {
    _currentTabIndex = index;
  }

  /// Exports the current settings to a json file.
  Future<bool?> onExportSettings(ExportData data) async {
    try {
      final String dataString =
          const JsonEncoder.withIndent('  ').convert(data.toJson());

      final String fileName =
          'pluto-settings-${data.createdAt.millisecondsSinceEpoch}.json';

      if (kIsWeb) {
        const String mimeType = 'application/json';
        final Uint8List bytes = utf8.encode(dataString);
        final html.Blob blob = html.Blob([bytes], mimeType);
        final html.AnchorElement anchorElement =
            html.AnchorElement(href: html.Url.createObjectUrlFromBlob(blob));
        anchorElement.download = fileName;
        anchorElement.click();
      } else {
        final String? path = await FilePicker.platform.saveFile(
          type: FileType.custom,
          lockParentWindow: true,
          allowedExtensions: ['json'],
          initialDirectory: 'Downloads',
          fileName: fileName,
          dialogTitle: 'Save File',
        );
        if (path == null) return null;
        final file = io.File(path);
        if (!await file.exists()) await file.create();
        await file.writeAsString(dataString);
      }

      messageBannerController.showNeutral(
        'Settings exported!',
        icon: const Icon(Icons.done),
      );

      return true;
    } catch (error, stackTrace) {
      log(error.toString());
      log(stackTrace.toString());
      messageBannerController.showError('Failed to export settings!');
      return false;
    }
  }

  /// Imports the current settings to a json file.
  Future<bool?> onImportSettings() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        lockParentWindow: true,
        allowedExtensions: ['json'],
        withData: true,
        allowMultiple: false,
      );
      if (result == null || result.files.isEmpty) return null;
      final file = result.files.first;
      final String content = utf8.decode(file.bytes!);

      final map = tryJsonDecode(content) as Map<String, dynamic>?;

      if (map == null) {
        messageBannerController.showError('Invalid settings file!');
        return false;
      }

      final ExportData data = ExportData.fromJson(map);

      if (data.version != settingsVersion) {
        messageBannerController.showError(
            'Settings file contains a version that is not supported by this '
            'version of Pluto.');
        return false;
      }

      await importDataToStorage(data);

      messageBannerController.showNeutral(
        'Settings imported!',
        icon: const Icon(Icons.done),
      );

      return true;
    } catch (error, stackTrace) {
      log(error.toString());
      log(stackTrace.toString());
      messageBannerController.showError('Failed to import settings!');
      return false;
    }
  }

  Future<void> importDataToStorage(ExportData data) async {
    final LocalStorageManager storage =
        GetIt.instance.get<LocalStorageManager>();

    // background settings
    await storage.setJson(
        StorageKeys.backgroundSettings, data.settings.toJson());

    // cached images
    await storage.setInt(StorageKeys.imageIndex, data.imageIndex);
    await storage.setInt('image1Time', data.image1Time.millisecondsSinceEpoch);
    await storage.setInt('image2Time', data.image2Time.millisecondsSinceEpoch);
    if (data.image1 != null) {
      await storage.setJson(StorageKeys.image1, data.image1!.toJson());
    }
    if (data.image2 != null) {
      await storage.setJson(StorageKeys.image2, data.image2!.toJson());
    }

    // liked images
    for (final (key, value) in data.likedBackgrounds.records) {
      await storage.setJson(key, value.toJson());
    }

    // widget settings
    final widgetSettings = data.widgetSettings;
    await storage.setEnum<WidgetType>(
        StorageKeys.widgetType, widgetSettings.type);

    await storage.setJson(
        StorageKeys.digitalClockSettings, widgetSettings.digitalClock.toJson());

    await storage.setJson(
        StorageKeys.analogueClockSettings, widgetSettings.analogClock.toJson());

    await storage.setJson(
        StorageKeys.messageSettings, widgetSettings.message.toJson());

    await storage.setJson(
        StorageKeys.timerSettings, widgetSettings.timer.toJson());

    await storage.setJson(
        StorageKeys.weatherSettings, widgetSettings.weather.toJson());

    await storage.setJson(
        StorageKeys.digitalDateSettings, widgetSettings.digitalDate.toJson());
  }

  void dispose() {
    tabController?.dispose();
    messageBannerController.dispose();
  }
}
