import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../model/widget_settings.dart';
import '../../ui/digital_clock.dart';
import '../../utils/custom_observer.dart';
import '../../utils/extensions.dart';
import '../background_store.dart';
import '../widget_store.dart';
import 'widget_decoration_wrapper.dart';

class DigitalClockWidget extends StatelessWidget {
  const DigitalClockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final BackgroundStore backgroundStore = context.read<BackgroundStore>();
    final settings = context.read<WidgetStore>().digitalClockSettings;

    return CustomObserver(
      name: 'DigitalClockWidget',
      builder: (context) {
        final String format = buildFormatString(settings.format, settings.separator.value);
        return Align(
          alignment: settings.alignment.flutterAlignment,
          child: FittedBox(
            child: WidgetDecorationWrapper(
              decoration: settings.decoration,
              horizontalPadding: settings.horizontalPadding,
              verticalPadding: settings.verticalPadding,
              horizontalMargin: settings.horizontalMargin,
              verticalMargin: settings.verticalMargin,
              child: DigitalClock(
                format: format,
                style: TextStyle(
                  fontSize: settings.fontSize,
                  letterSpacing: 4,
                  fontFamily: settings.fontFamily,
                  color: backgroundStore.foregroundColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String buildFormatString(ClockFormat format, String separator) {
    switch (format) {
      case ClockFormat.twelveHour:
        return 'hh${separator}mm';
      case ClockFormat.twelveHoursWithAmPm:
        return 'hh${separator}mm a';
      case ClockFormat.twentyFourHour:
        return 'HH${separator}mm';
    }
  }
}
