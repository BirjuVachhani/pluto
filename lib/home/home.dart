import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../settings/settings_panel.dart';
import '../utils/utils.dart';
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
          create: (context) => BackgroundModel()..init(),
        ),
        ChangeNotifierProvider<WidgetModelBase>(
          create: (context) => WidgetModel()..init(),
        ),
      ],
      child: const Home(),
    );
  }
}

abstract class HomeModelBase with ChangeNotifier, LazyInitializationMixin {
  bool isPanelVisible = false;

  void showPanel();

  void hidePanel();
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
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
}
