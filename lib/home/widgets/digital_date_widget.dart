// import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../model/widget_settings.dart';
import '../../ui/digital_date.dart';
import '../../utils/custom_observer.dart';
import '../../utils/extensions.dart';
import '../background_store.dart';
import '../widget_store.dart';

class DigitalDateWidget extends StatelessWidget {
  const DigitalDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final BackgroundStore backgroundStore = context.read<BackgroundStore>();
    final settings = context.read<WidgetStore>().digitalDateSettings;

    return CustomObserver(
      name: 'DigitalDateWidget',
      builder: (context) {
        final double borderWidth = (10 + settings.fontSize) * 0.15;
        final double paddingHorizontal = (20 + settings.fontSize) * 0.5;
        final double paddingVertical = (20 + settings.fontSize) * 0.4;
        final double round = (20 + settings.fontSize) * 0.5;
        String format =
            buildFormatString(settings.format, settings.separator.value);

        if (settings.format == DateFormat.custom) {
          // Use the custom format if the special format is selected
          format = settings.customFormat;
        }

        return Padding(
          padding:
              EdgeInsets.all(settings.borderType == BorderType.none ? 0 : 48),
          child: Align(
            alignment: settings.alignment.flutterAlignment,
            child: FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DigitalDate(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontal,
                        vertical: paddingVertical),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String buildFormatString(DateFormat format, String separator) {
    // final random = Random();

    switch (format) {
      case DateFormat.dayMonthYear:
        return 'dd${separator}MM${separator}yyyy';
      case DateFormat.monthDayYear:
        return 'MM${separator}dd${separator}yyyy';
      case DateFormat.yearMonthDay:
        return 'yyyy${separator}MM${separator}dd';
      case DateFormat.custom:
        return 'dd $separator MMMM $separator yyyy';
      // case DateFormat.random:
      //   final components = ['dd', 'MM', 'yyyy']..shuffle(random);
      //   return components.join(separator);
      default:
        return 'dd${separator}MM${separator}yyyy'; // Default to a format
    }
  }
}
