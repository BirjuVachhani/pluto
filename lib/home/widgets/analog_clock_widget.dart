import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ui/analog_clock.dart';
import '../../utils/custom_observer.dart';
import '../../utils/extensions.dart';
import '../background_model.dart';
import '../home_widget.dart';

class AnalogClockWidget extends StatelessWidget {
  const AnalogClockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final BackgroundStore backgroundStore = context.read<BackgroundStore>();
    return CustomObserver(
      name: 'Analog Clock',
      builder: (context) {
        return Consumer<WidgetModelBase>(
          builder: (context, model, child) {
            final settings = model.analogueClockSettings;
            return Align(
              alignment: settings.alignment.flutterAlignment,
              child: Padding(
                padding: const EdgeInsets.all(56),
                child: FittedBox(
                  child: AnalogClock(
                    showSecondsHand: settings.showSecondsHand,
                    secondHandColor:
                        settings.coloredSecondHand ? Colors.red : null,
                    radius: settings.radius,
                    color: backgroundStore.foregroundColor,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
