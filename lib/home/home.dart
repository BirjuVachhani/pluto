import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../settings/settings_panel.dart';
import '../utils/utils.dart';
import 'background_model.dart';
import 'bottom_bar.dart';
import 'home_background.dart';
import 'home_widget.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeModelBase>(
          create: (context) => HomeModel()..init(),
        ),
        ChangeNotifierProvider<BackgroundModelBase>(
          create: (context) => BackgroundModel(),
        ),
        ChangeNotifierProvider<WidgetModelBase>(
          create: (context) => WidgetModel()..init(),
        ),
      ],
      child: const Home(key: ValueKey('Home')),
    );
  }
}

abstract class HomeModelBase with ChangeNotifier, LazyInitializationMixin {
  bool isPanelVisible = false;

  int currentTabIndex = 0;
  late final TabController tabController;

  void showPanel();

  void hidePanel();

  Future<void> reset();
}

class HomeModel extends HomeModelBase {
  @override
  Future<void> init() async {
    // Initialize stuff
    initialized = true;
    notifyListeners();
  }

  @override
  void showPanel() {
    isPanelVisible = true;
    notifyListeners();
  }

  @override
  void hidePanel() {
    isPanelVisible = false;
    notifyListeners();
  }

  @override
  Future<void> reset() async {
    isPanelVisible = false;
    initialized = false;
    currentTabIndex = 0;
    notifyListeners();
    await init();
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final BackgroundModelBase model = context.read<BackgroundModelBase>();

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    model.initializationFuture.then((_) {
      listenToEvents();
      // Start the timer for auto background refresh only if required.
      if (!model.imageRefreshRate.requiresTimer) return;
      startTimer();
    });
  }

  void listenToEvents() {
    model.addListener(onBackgroundModelChange);
  }

  /// Start and stop timer based on the current [ImageRefreshRate] when
  /// changed from settings panel. Doing this allows us to avoid unnecessary
  /// timer updates.
  void onBackgroundModelChange() {
    if (model.imageRefreshRate.requiresTimer) {
      startTimer();
    } else if (!model.imageRefreshRate.requiresTimer) {
      stopTimer();
    }
  }

  /// Start the timer for auto background refresh.
  void startTimer() {
    if (_timer != null) return;
    log('Starting timer for background refresh');
    _timer = Timer.periodic(
        const Duration(seconds: 1), (timer) => model.onTimerCallback());
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
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: const [
            Positioned.fill(child: HomeBackground()),
            Positioned.fill(child: HomeWidget()),
            Align(alignment: Alignment.bottomCenter, child: BottomBar()),
            SettingsPanel(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
