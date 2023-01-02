import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/widget_settings.dart';
import '../utils/custom_observer.dart';
import 'widget_store.dart';
import 'widgets/analog_clock_widget.dart';
import 'widgets/digital_clock_widget.dart';
import 'widgets/message_widget.dart';
import 'widgets/timer_widget.dart';
import 'widgets/weather_widget.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.read<WidgetStore>();
    return CustomObserver(
      name: 'HomeWidget',
      builder: (context) {
        if (!store.initialized) return const SizedBox.shrink();
        switch (store.type) {
          case WidgetType.none:
            return const SizedBox.shrink();
          case WidgetType.digitalClock:
            return const DigitalClockWidget();
          case WidgetType.analogClock:
            return const AnalogClockWidget();
          case WidgetType.text:
            return const MessageWidget();
          case WidgetType.timer:
            return const TimerWidget();
          case WidgetType.weather:
            final latitude = store.weatherSettings.location.latitude;
            final longitude = store.weatherSettings.location.longitude;
            return WeatherWidgetWrapper(
              key: ValueKey('$latitude, $longitude'),
              latitude: latitude,
              longitude: longitude,
            );
        }
      },
    );
  }
}
