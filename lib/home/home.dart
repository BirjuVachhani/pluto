import 'dart:async';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../model/background_settings.dart';
import '../resources/storage_keys.dart';
import '../settings/changelog_dialog.dart';
import '../settings/settings_panel.dart';
import '../ui/message_banner/message_banner.dart';
import '../ui/message_banner/message_view.dart';
import '../utils/custom_observer.dart';
import '../utils/storage_manager.dart';
import '../utils/universal/universal.dart';
import '../utils/utils.dart';
import 'background_store.dart';
import 'bottom_bar.dart';
import 'home_background.dart';
import 'home_store.dart';
import 'home_widget.dart';
import 'widget_store.dart';

const bool isDevMode = String.fromEnvironment('MODE') == 'debug';
const bool useLocalServer = String.fromEnvironment('SERVER') == 'local';

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
  late final BackgroundStore backgroundStore = context.read<BackgroundStore>();
  late final HomeStore store = context.read<HomeStore>();

  late final LocalStorageManager storageManager =
      GetIt.instance.get<LocalStorageManager>();

  ReactionDisposer? _disposer;

  Timer? _timer;

  final GlobalKey homeKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    backgroundStore.initializationFuture.then((_) {
      listenToEvents();
      // Start the timer for auto background refresh only if required.
      if (!backgroundStore.backgroundRefreshRate.requiresTimer) return;
      startTimer();
    });
    _shouldShowChangelog();
  }

  void listenToEvents() {
    _disposer = reaction(
        (react) => backgroundStore.backgroundRefreshRate, onRefreshRateChanged);
  }

  /// Start and stop timer based on the current [BackgroundRefreshRate] when
  /// changed from settings panel. Doing this allows us to avoid unnecessary
  /// timer updates.
  void onRefreshRateChanged(BackgroundRefreshRate refreshRate) {
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
    _timer = Timer.periodic(const Duration(seconds: 1),
        (timer) => backgroundStore.onTimerCallback());
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
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            // App
            RepaintBoundary(
              key: homeKey,
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  const Positioned.fill(
                      child: RepaintBoundary(child: HomeBackground())),
                  const Positioned.fill(
                      child: RepaintBoundary(child: HomeWidget())),
                  const Align(
                      alignment: Alignment.bottomCenter, child: BottomBar()),
                  const RepaintBoundary(child: SettingsPanel()),
                  Positioned(
                    bottom: 48,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: MessageBanner(
                        controller: store.messageBannerController,
                        maxLines: 1,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        bannerStyle: MessageBannerStyle.solid,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isDevMode) ...[
              Positioned(
                top: 16,
                right: 16,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: onScreenshot,
                      iconSize: 20,
                      tooltip: 'Screenshot',
                      icon: const Icon(Icons.photo_size_select_actual_outlined),
                    ),
                    const SizedBox(width: 8),
                    CustomObserver(
                      name: 'Image Index',
                      builder: (context) {
                        return Text(
                          backgroundStore.imageIndex.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: CustomObserver(
                  name: 'Image Time',
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '0: ${DateFormat('dd/MM/yyyy hh:mm a').format(backgroundStore.image1Time)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '1: ${DateFormat('dd/MM/yyyy hh:mm a').format(backgroundStore.image2Time)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> onScreenshot() async {
    // take a screenshot with homeKey and save.
    final Uint8List imageBytes = await takeScreenshot(homeKey);
    final fileName =
        'background_${DateTime.now().millisecondsSinceEpoch ~/ 1000}.jpg';

    if (kIsWeb) {
      return downloadImage(imageBytes, fileName);
    }

    /// Show native save file dialog on desktop.
    final String? path = await FilePicker.platform.saveFile(
      type: FileType.image,
      dialogTitle: 'Save Image',
      fileName: fileName,
    );
    if (path == null) return;

    downloadImage(imageBytes, path);
  }

  Future<void> _shouldShowChangelog() async {
    final String? storedVersion =
        await storageManager.getString(StorageKeys.version);
    if (storedVersion == null || storedVersion != packageInfo.version) {
      log('Showing changelog dialog');
      await storageManager.setString(StorageKeys.version, packageInfo.version);
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

  @override
  void dispose() {
    _timer?.cancel();
    _disposer?.reaction.dispose();
    super.dispose();
  }
}
