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
            '${settings.format == ClockFormat.twelveHour ? 'hh' : 'HH'}${settings.separator.value}mm';
        return Align(
          alignment: settings.alignment.flutterAlignment,
          child: FittedBox(
            child: DigitalClock(
              padding: EdgeInsets.symmetric(
                  horizontal: paddingHorizontal, vertical: paddingVertical),
              decoration: BoxDecoration(
                borderRadius: settings.borderType == BorderType.rounded
                    ? BorderRadius.circular(round)
                    : null,
                border: settings.borderType != BorderType.none
                    ? Border.all(
                        color: backgroundStore.foregroundColor,
                        width: borderWidth,
                      )
                    : null,
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
        );
      },
    );
  }
}
