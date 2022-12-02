import 'dart:math';

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
              child: const SettingsButton(),
            ),
          ),
          const SettingsPanel(),
        ],
      ),
    );
  }
}

class SettingsButton extends StatefulWidget {
  const SettingsButton({super.key});

  @override
  State<SettingsButton> createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.read<BackgroundModelBase>().getForegroundColor();
    return GestureDetector(
      onTap: () => context.read<SettingsPanelModelBase>().show(),
      child: MouseRegion(
        onEnter: (_) => controller.forward(),
        onExit: (_) => controller.reverse(),
        child: Tooltip(
          message: 'Settings',
          waitDuration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          verticalOffset: 18,
          textStyle: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            color: Colors.black,
          ),
          child: AnimatedBuilder(
            animation: CurvedAnimation(
              parent: controller,
              curve: Curves.fastOutSlowIn,
            ),
            builder: (context, child) {
              return Transform.rotate(
                angle: controller.value * pi / pi,
                child: Icon(
                  Icons.settings,
                  color: color.withOpacity(max(0.2, controller.value)),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
