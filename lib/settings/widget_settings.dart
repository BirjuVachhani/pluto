import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/home_widget.dart';
import '../model/widget_settings.dart';
import '../ui/custom_dropdown.dart';
import 'widget_settings/analog_clock_widget_settings.dart';
import 'widget_settings/digital_clock_widget_settings.dart';

class WidgetSettings extends StatelessWidget {
  const WidgetSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WidgetModelBase>(
      builder: (context, model, child) {
        if (!model.initialized) return const SizedBox(height: 200);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomDropdown<WidgetType>(
              value: model.type,
              label: 'Widget',
              isExpanded: true,
              items: WidgetType.values,
              itemBuilder: (context, item) => Text(item.label),
              onSelected: (type) => model.setType(type),
            ),
            _SettingsWidget(key: ValueKey(model.type), type: model.type),
          ],
        );
      },
    );
  }
}

class _SettingsWidget extends StatelessWidget {
  final WidgetType type;

  const _SettingsWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case WidgetType.digitalClock:
        return const DigitalClockWidgetSettingsView();
      case WidgetType.analogClock:
        return const AnalogClockWidgetSettingsView();
      case WidgetType.none:
        return const SizedBox(height: 16);
    }
  }
}
