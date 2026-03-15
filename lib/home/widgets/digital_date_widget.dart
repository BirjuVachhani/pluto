import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../model/widget_settings.dart';
import '../../ui/digital_date.dart';
import '../../utils/custom_observer.dart';
import '../../utils/extensions.dart';
import '../background_store.dart';
import '../widget_store.dart';
import 'widget_decoration_wrapper.dart';

class DigitalDateWidget extends StatelessWidget {
  const DigitalDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final BackgroundStore backgroundStore = context.read<BackgroundStore>();
    final settings = context.read<WidgetStore>().digitalDateSettings;

    return CustomObserver(
      name: 'DigitalDateWidget',
      builder: (context) {
        String format = buildFormatString(settings.format, settings.separator.value);

        if (settings.format == DateFormat.custom) {
          format = settings.customFormat;
        }

        return Align(
          alignment: settings.alignment.flutterAlignment,
          child: FittedBox(
            child: WidgetDecorationWrapper(
              decoration: settings.decoration,
              horizontalPadding: settings.horizontalPadding,
              verticalPadding: settings.verticalPadding,
              horizontalMargin: settings.horizontalMargin,
              verticalMargin: settings.verticalMargin,
              child: DigitalDate(
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

  String buildFormatString(DateFormat format, String separator) {
    return switch (format) {
      DateFormat.dayMonthYear => 'dd${separator}MM${separator}yyyy',
      DateFormat.monthDayYear => 'MM${separator}dd${separator}yyyy',
      DateFormat.yearMonthDay => 'yyyy${separator}MM${separator}dd',
      DateFormat.custom => 'dd $separator MMMM $separator yyyy',
    };
  }
}
