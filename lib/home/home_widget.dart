import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_background.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BackgroundModelBase>(
      builder: (context, model, child) {
        return Text(
          'Hello!',
          style: TextStyle(
            fontSize: 56,
            color: getColor(model),
          ),
        );
      },
    );
  }

  Color? getColor(BackgroundModelBase model) {
    if (model.mode.isColor) return model.color?.foreground;
    if (model.mode.isGradient) return model.gradient?.foreground;
    return Colors.black;
  }
}
