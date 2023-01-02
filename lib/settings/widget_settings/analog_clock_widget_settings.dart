import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/widget_store.dart';
import '../../ui/alignment_control.dart';
import '../../ui/custom_slider.dart';
import '../../ui/custom_switch.dart';
import '../../utils/custom_observer.dart';

class AnalogClockWidgetSettingsView extends StatelessWidget {
  const AnalogClockWidgetSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.read<WidgetStore>().analogueClockSettings;
    return Column(
      children: [
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Radius',
          builder: (context) {
            return CustomSlider(
              min: 10,
              max: 400,
              valueLabel: '${settings.radius.floor()} px',
              value: settings.radius,
              onChanged: (value) =>
                  settings.update(() => settings.radius = value),
            );
          },
        ),
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Position',
          builder: (context) {
            return AlignmentControl(
              alignment: settings.alignment,
              onChanged: (alignment) =>
                  settings.update(() => settings.alignment = alignment),
            );
          },
        ),
        const SizedBox(height: 16),
        CustomObserver(
          name: 'Show seconds',
          builder: (context) {
            return CustomSwitch(
              label: 'Show seconds',
              value: settings.showSecondsHand,
              onChanged: (value) =>
                  settings.update(() => settings.showSecondsHand = value),
            );
          },
        ),
        const SizedBox(height: 4),
        CustomObserver(
          name: 'Colored Second Hand',
          builder: (context) {
            return CustomSwitch(
              label: 'Colored Second Hand',
              value: settings.coloredSecondHand,
              onChanged: (value) =>
                  settings.update(() => settings.coloredSecondHand = value),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
