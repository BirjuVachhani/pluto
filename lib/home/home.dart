import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'widget_store.dart';
import 'package:provider/provider.dart';

import '../model/background_settings.dart';
import '../resources/storage_keys.dart';
import '../settings/changelog_dialog.dart';
import '../settings/settings_panel.dart';
import '../src/version.dart';
import '../utils/storage_manager.dart';
import 'background_store.dart';
import 'bottom_bar.dart';
import 'home_background.dart';
import 'home_store.dart';
import 'home_widget.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<HomeStore>(
          create: (context) => HomeStore(),
          dispose: (context, store) => store.dispose(),
        ),
        Provider<BackgroundStore>(
          create: (context) => BackgroundStore(),
          dispose: (context, store) => store.dispose(),
        ),
        Provider<WidgetStore>(
          create: (context) => WidgetStore(),
        ),
      ],
      child: const Home(key: ValueKey('Home')),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final BackgroundStore store = context.read<BackgroundStore>();

  late final LocalStorageManager storageManager =
      GetIt.instance.get<LocalStorageManager>();

  ReactionDisposer? _disposer;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    store.initializationFuture.then((_) {
      listenToEvents();
      // Start the timer for auto background refresh only if required.
      if (!store.imageRefreshRate.requiresTimer) return;
      startTimer();
    });
    _shouldShowChangelog();
  }

  void listenToEvents() {
    _disposer =
        reaction((react) => store.imageRefreshRate, onRefreshRateChanged);
  }

  /// Start and stop timer based on the current [ImageRefreshRate] when
  /// changed from settings panel. Doing this allows us to avoid unnecessary
  /// timer updates.
  void onRefreshRateChanged(ImageRefreshRate refreshRate) {
    if (refreshRate.requiresTimer) {
      startTimer();
    } else if (!refreshRate.requiresTimer) {
      stopTimer();
    }
  }

  /// Start the timer for auto background refresh.
  void startTimer() {
    if (_timer != null) return;
    log('Starting timer for background refresh');
    _timer = Timer.periodic(
        const Duration(seconds: 1), (timer) => store.onTimerCallback());
  }

  /// Stop the timer for auto background refresh.
  void stopTimer() {
    if (_timer == null) return;
    log('Stopping timer for background refresh');
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Positioned.fill(child: RepaintBoundary(child: HomeBackground())),
            Positioned.fill(child: RepaintBoundary(child: HomeWidget())),
            Align(alignment: Alignment.bottomCenter, child: BottomBar()),
            RepaintBoundary(child: SettingsPanel()),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _disposer?.reaction.dispose();
    super.dispose();
  }

  Future<void> _shouldShowChangelog() async {
    final String? storedVersion =
        await storageManager.getString(StorageKeys.version);
    if (storedVersion == null || storedVersion != packageVersion) {
      log('Showing changelog dialog');
      await storageManager.setString(StorageKeys.version, packageVersion);
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => const Material(
          type: MaterialType.transparency,
          child: ChangelogDialog(),
        ),
      );
    }
  }
}
