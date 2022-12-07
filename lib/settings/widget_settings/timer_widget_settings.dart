import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../home/home_widget.dart';
import '../../model/widget_settings.dart';
import '../../resources/fonts.dart';
import '../../ui/alignment_control.dart';
import '../../ui/custom_dropdown.dart';
import '../../ui/custom_slider.dart';
import '../../ui/resizable_text_input.dart';
import '../../ui/text_input.dart';
import '../../utils/extensions.dart';

class TimerWidgetSettingsView extends StatelessWidget {
  const TimerWidgetSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WidgetModelBase>(
      builder: (context, model, child) {
        final settings = model.timerSettings;
        return Column(
          children: [
            const SizedBox(height: 16),
            CustomDropdown<String>(
              label: 'Font',
              isExpanded: true,
              value: settings.fontFamily,
              items: FontFamilies.fonts,
              onSelected: (family) => model.updateTimerSettings(
                settings.copyWith(fontFamily: family),
              ),
            ),
            const SizedBox(height: 16),
            CustomSlider(
              label: 'Font size',
              min: 10,
              max: 400,
              valueLabel: '${settings.fontSize.floor().toString()} px',
              value: settings.fontSize,
              onChanged: (value) => model.updateTimerSettings(
                settings.copyWith(fontSize: value.floorToDouble()),
              ),
            ),
            const SizedBox(height: 16),
            AlignmentControl(
              label: 'Position',
              alignment: settings.alignment,
              onChanged: (alignment) => model.updateTimerSettings(
                settings.copyWith(alignment: alignment),
              ),
            ),
            const SizedBox(height: 16),
            CustomDropdown<TimerFormat>(
              label: 'Format',
              isExpanded: true,
              value: settings.format,
              items: TimerFormat.values,
              itemBuilder: (context, format) => Text(format.label),
              onSelected: (format) => model.updateTimerSettings(
                settings.copyWith(format: format),
              ),
            ),
            const SizedBox(height: 16),
            ResizableTextInput(
              label: 'Text Before',
              initialHeight: 50,
              initialValue: settings.textBefore,
              onChanged: (message) => model.updateTimerSettings(
                settings.copyWith(textBefore: message),
                save: false,
              ),
              onSubmitted: (message) => model.updateTimerSettings(
                settings.copyWith(textBefore: message),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 114,
                  child: TextInput(
                    label: 'Date',
                    textStyle: const TextStyle(letterSpacing: 0.8),
                    textInputAction: TextInputAction.next,
                    inputFormatters: [MaskedInputFormatter('00/00/0000')],
                    hintText: 'dd/mm/yyyy',
                    initialValue:
                        DateFormat('dd/MM/yyyy').format(settings.time),
                    contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                    onSubmitted: (value) {
                      if (value.isEmpty || value.length < 10) return false;
                      final parsed = DateFormat('dd/MM/yyyy').parse(value);
                      model.updateTimerSettings(
                        settings.copyWith(
                          time: settings.time.copyWith(
                            day: parsed.day,
                            month: parsed.month,
                            year: parsed.year,
                            hour: settings.time.hour,
                            minute: settings.time.minute,
                            second: 0,
                            millisecond: 0,
                          ),
                        ),
                      );
                      return true;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 96,
                  child: TextInput(
                    label: 'Time',
                    textStyle: const TextStyle(letterSpacing: 0.2),
                    inputFormatters: [
                      MaskedInputFormatter(
                        '00:00 ##',
                        allowedCharMatcher: RegExp(r'[0-9:AMP]+'),
                      )
                    ],
                    hintText: 'hh:mm aa',
                    initialValue: DateFormat('hh:mm aa').format(settings.time),
                    onSubmitted: (value) {
                      if (value.isEmpty || value.length < 5) return false;
                      final tokens = value.split(':');
                      int minutes = int.parse(tokens[1].split(' ')[0]);
                      bool isPM = tokens[1].split(' ')[1] == 'PM';
                      int hours = int.parse(tokens[0]) % (12);
                      if (isPM && hours < 12) hours += 12;
                      model.updateTimerSettings(
                        settings.copyWith(
                          time: settings.time.copyWith(
                            hour: hours,
                            minute: minutes,
                            second: 0,
                            millisecond: 0,
                          ),
                        ),
                      );
                      return true;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ResizableTextInput(
              label: 'Text After',
              initialHeight: 100,
              initialValue: settings.textAfter,
              onChanged: (message) => model.updateTimerSettings(
                settings.copyWith(textAfter: message),
                save: false,
              ),
              onSubmitted: (message) => model.updateTimerSettings(
                settings.copyWith(textAfter: message),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
