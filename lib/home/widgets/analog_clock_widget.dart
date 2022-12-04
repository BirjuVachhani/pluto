import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ui/analog_clock.dart';
import '../background_model.dart';
import '../home_widget.dart';

class AnalogClockWidget extends StatelessWidget {
  const AnalogClockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<BackgroundModelBase, WidgetModelBase>(
      builder: (context, backgroundModel, model, child) {
        final settings = model.analogueClockSettings;
        return Center(
          child: FittedBox(
            child: AnalogClock(
              showSecondsHand: settings.showSecondsHand,
              secondHandColor: settings.coloredSecondHand ? Colors.red : null,
              radius: settings.radius,
              color: backgroundModel.getForegroundColor(),
            ),
          ),
        );
      },
    );
  }
}
