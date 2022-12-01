import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../settings/settings_panel.dart';
import 'home_background.dart';
import 'home_model.dart';
import 'home_widget.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeModelBase>(
          create: (context) => HomeModel(),
        ),
        ChangeNotifierProvider<SettingsPanelModelBase>(
          create: (context) => SettingsPanelModel(),
        ),
        ChangeNotifierProvider<BackgroundModelBase>(
          create: (context) => BackgroundModel()..init(),
        ),
      ],
      child: const Home(),
    );
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
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          const Align(
            alignment: Alignment.center,
            child: HomeWidget(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 48,
              alignment: Alignment.center,
              child: IconButton(
                splashRadius: 18,
                color: context.read<BackgroundModelBase>().color?.foreground.withOpacity(0.2),
                icon: const Icon(Icons.settings),
                onPressed: () {
                  context.read<SettingsPanelModelBase>().show();
                },
              ),
            ),
          ),
          const SettingsPanel(),
        ],
      ),
    );
  }
}
