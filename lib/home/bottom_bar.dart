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
      return Horizon(
        color: model.getForegroundColor(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
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
        ),
      );
    });
  }
}

class Horizon extends StatefulWidget {
  final Widget child;
  final Color? color;

  const Horizon({
    super.key,
    required this.child,
    this.color,
  });

  @override
  State<Horizon> createState() => _HorizonState();
}

class _HorizonState extends State<Horizon> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedOpacity(
              opacity: hovering ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
              child: Container(
                height: 150,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      (widget.color ?? Colors.white).withOpacity(1),
                      (widget.color ?? Colors.white).withOpacity(0.7),
                      Colors.transparent,
                    ],
                    stops: const [0.25, 0.3, 0.35],
                    center: const Alignment(0, 20.2),
                    focalRadius: 1,
                    radius: 30,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MouseRegion(
              onEnter: (_) => setState(() => hovering = true),
              onExit: (_) => setState(() => hovering = false),
              child: ColoredBox(
                color: Colors.transparent,
                child: widget.child,
              ),
            ),
          ),
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
