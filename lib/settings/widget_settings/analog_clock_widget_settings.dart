import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/home_widget.dart';
import '../../ui/custom_slider.dart';
import '../../ui/custom_switch.dart';

class AnalogClockWidgetSettingsView extends StatelessWidget {
  const AnalogClockWidgetSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WidgetModelBase>(
      builder: (context, model, child) {
        final settings = model.analogueClockSettings;
        return Column(
          children: [
            const SizedBox(height: 16),
            CustomSlider(
              label: 'Radius',
              min: 10,
              max: 400,
              valueLabel: '${settings.radius.floor()} px',
              value: settings.radius,
              onChanged: (value) => model.updateAnalogClockSettings(
                settings.copyWith(radius: value),
              ),
            ),
            const SizedBox(height: 16),
            CustomSwitch(
              label: 'Show seconds',
              value: settings.showSecondsHand,
              onChanged: (value) => model.updateAnalogClockSettings(
                settings.copyWith(showSecondsHand: value),
              ),
            ),
            const SizedBox(height: 4),
            CustomSwitch(
              label: 'Colored Second Hand',
              value: settings.coloredSecondHand,
              onChanged: (value) => model.updateAnalogClockSettings(
                settings.copyWith(coloredSecondHand: value),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
