import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../model/widget_settings.dart';
import '../../ui/digital_clock.dart';
import '../../utils/custom_observer.dart';
import '../../utils/extensions.dart';
import '../background_store.dart';
import '../widget_store.dart';

class DigitalClockWidget extends StatelessWidget {
  const DigitalClockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final BackgroundStore backgroundStore = context.read<BackgroundStore>();
    final settings = context.read<WidgetStore>().digitalClockSettings;

    return CustomObserver(
      name: 'DigitalClockWidget',
      builder: (context) {
        final double borderWidth = (10 + settings.fontSize) * 0.15;
        final double paddingHorizontal = (20 + settings.fontSize) * 0.5;
        final double paddingVertical = (20 + settings.fontSize) * 0.4;
        final double round = (20 + settings.fontSize) * 0.5;
        final String format =
            buildFormatString(settings.format, settings.separator.value);
        return Padding(
          padding:
              EdgeInsets.all(settings.borderType == BorderType.none ? 0 : 48),
          child: Align(
            alignment: settings.alignment.flutterAlignment,
            child: FittedBox(
              child: DigitalClock(
                padding: EdgeInsets.symmetric(
                    horizontal: paddingHorizontal, vertical: paddingVertical),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: settings.borderType == BorderType.rounded
                        ? BorderRadius.circular(round)
                        : BorderRadius.zero,
                    side: settings.borderType != BorderType.none
                        ? BorderSide(
                            color: backgroundStore.foregroundColor,
                            width: borderWidth,
                          )
                        : BorderSide.none,
                  ),
                ),
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
