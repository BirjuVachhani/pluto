import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ui/gesture_detector_with_cursor.dart';
import 'home.dart';
import 'home_background.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      child: const SettingsButton(),
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
    return Consumer<BackgroundModelBase>(builder: (context, model, child) {
      if (!model.initialized) return const SizedBox.shrink();
      return GestureDetector(
        child: GestureDetectorWithCursor(
          onTap: () {
            context.read<HomeModelBase>().showPanel();
          },
          onEnter: (_) => controller.forward(),
          onExit: (_) => controller.reverse(),
          tooltip: 'Settings',
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
                  color: model
                      .getForegroundColor()
                      .withOpacity(max(0.2, controller.value)),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
