import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/widget_store.dart';
import '../model/widget_settings.dart';
import '../ui/custom_dropdown.dart';
import '../utils/custom_observer.dart';
import 'widget_settings/analog_clock_widget_settings.dart';
import 'widget_settings/digital_clock_widget_settings.dart';
import 'widget_settings/message_widget_settings.dart';
import 'widget_settings/timer_widget_settings.dart';
import 'widget_settings/weather_widget_settings.dart';

class WidgetSettings extends StatelessWidget {
  const WidgetSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.read<WidgetStore>();
    return CustomObserver(
      name: 'WidgetSettings',
      builder: (context) {
        if (!store.initialized) return const SizedBox(height: 200);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            LabeledObserver(
              label: 'Widget',
              builder: (context) {
                return CustomDropdown<WidgetType>(
                  value: store.type,
                  isExpanded: true,
                  items: WidgetType.values,
                  itemBuilder: (context, item) => Text(item.label),
                  onSelected: (type) => store.setType(type),
                );
              },
            ),
            CustomObserver(
              name: '_SettingsWidget',
              builder: (context) {
                switch (store.type) {
                  case WidgetType.none:
                    return const SizedBox(height: 16);
                  case WidgetType.digitalClock:
                    return const DigitalClockWidgetSettingsView();
                  case WidgetType.analogClock:
                    return const AnalogClockWidgetSettingsView();
                  case WidgetType.text:
                    return const MessageWidgetSettingsView();
                  case WidgetType.timer:
                    return const TimerWidgetSettingsView();
                  case WidgetType.weather:
                    return const WeatherWidgetSettingsView();
                }
              },
            )
          ],
        );
      },
    );
  }
}
