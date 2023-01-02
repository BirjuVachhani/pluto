import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../main.dart';

const List<Color> _colors = [
  Colors.red,
  Colors.green,
  Colors.yellow,
  Colors.purple,
  Colors.orange,
  Colors.pink,
  Colors.teal,
  Colors.cyan,
  Colors.lime,
];

/// A widget that wraps its child in a highlighting border which shows up
/// when the observer or its builder is rebuilt.
/// This only works when [DebugRender.debugHighlightObserverRebuild] is true.
class CustomObserver extends StatelessWidget {
  final WidgetBuilder builder;
  final String name;

  const CustomObserver({
    super.key,
    required this.builder,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    log('Rebuilding Observer $name');
    final color = _colors[name.hashCode % _colors.length];
    return Observer(
      name: name,
      builder: (context) {
        if (!kDebugMode ||
            DebugRender.of(context)?.debugHighlightObserverRebuild != true) {
          return builder(context);
        }
        log('Rebuilding $name');
        return TweenAnimationBuilder<double>(
          key: ValueKey(DateTime.now().second),
          tween: Tween<double>(begin: -1, end: 1),
          duration: const Duration(milliseconds: 3000),
          builder: (context, value, child) {
            final opacity = min(1 + value * (value > 0 ? -1 : 1), 0.5);

            return Material(
              type: MaterialType.transparency,
              borderOnForeground: true,
              animationDuration: Duration.zero,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: color.withOpacity(opacity),
                  width: 4,
                ),
              ),
              child: child,
            );
          },
          child: builder(context),
        );
      },
    );
  }
}

class LabeledObserver extends StatelessWidget {
  final WidgetBuilder builder;
  final String label;
  final double spacing;

  const LabeledObserver({
    super.key,
    required this.builder,
    required this.label,
    this.spacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label),
        SizedBox(height: spacing),
        CustomObserver(name: label, builder: builder),
      ],
    );
  }
}
