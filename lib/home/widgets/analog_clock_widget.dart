import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ui/analog_clock.dart';
import '../../utils/custom_observer.dart';
import '../../utils/extensions.dart';
import '../background_store.dart';
import '../widget_store.dart';
import 'widget_decoration_wrapper.dart';

class AnalogClockWidget extends StatelessWidget {
  const AnalogClockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final BackgroundStore backgroundStore = context.read<BackgroundStore>();
    final settings = context.read<WidgetStore>().analogueClockSettings;

    return CustomObserver(
      name: 'Analog Clock',
      builder: (context) {
        return Align(
          alignment: settings.alignment.flutterAlignment,
          child: FittedBox(
            child: WidgetDecorationWrapper(
              decoration: settings.decoration,
              horizontalPadding: settings.horizontalPadding,
              verticalPadding: settings.verticalPadding,
              horizontalMargin: settings.horizontalMargin,
              verticalMargin: settings.verticalMargin,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: AnalogClock(
                  showSecondsHand: settings.showSecondsHand,
                  secondHandColor: settings.coloredSecondHand ? Colors.red : null,
                  radius: settings.radius,
                  color: backgroundStore.foregroundColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
