import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ui/gesture_detector_with_cursor.dart';
import 'background_model.dart';
import 'home.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BackgroundModelBase>(builder: (context, model, child) {
      if (!model.initialized) return const SizedBox.shrink();
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (model.mode.isImage) ...[
                const ChangeBackgroundButton(),
                const SizedBox(width: 24),
              ],
              const SettingsButton(),
            ],
          ),
          Container(
            width: 132,
            height: 2,
            margin: const EdgeInsets.only(bottom: 6, top: 6),
            child: Visibility(
              visible: model.isLoadingImage,
              child: LinearProgressIndicator(
                color: model.getForegroundColor(),
                minHeight: 2,
                backgroundColor: model.getForegroundColor().withOpacity(0.3),
              ),
            ),
          ),
        ],
      );
    });
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

class ChangeBackgroundButton extends StatefulWidget {
  const ChangeBackgroundButton({super.key});

  @override
  State<ChangeBackgroundButton> createState() => _ChangeBackgroundButtonState();
}

class _ChangeBackgroundButtonState extends State<ChangeBackgroundButton>
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
          onTap: !model.isLoadingImage ? model.changeBackground : null,
          onEnter: (_) => controller.forward(),
          onExit: (_) => controller.reverse(),
          tooltip: 'Change Background',
          child: AnimatedBuilder(
            animation: CurvedAnimation(
              parent: controller,
              curve: Curves.fastOutSlowIn,
            ),
            builder: (context, child) {
              return ImageIcon(
                AssetImage(model.isLoadingImage
                    ? 'assets/images/ic_hourglass.png'
                    : 'assets/images/ic_fan.png'),
                color: model
                    .getForegroundColor()
                    .withOpacity(max(0.2, controller.value)),
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
