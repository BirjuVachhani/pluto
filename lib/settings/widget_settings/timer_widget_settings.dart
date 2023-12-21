import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart' as timer;
import 'package:provider/provider.dart';

import '../../home/widget_store.dart';
import '../../model/widget_settings.dart';
import '../../resources/fonts.dart';
import '../../ui/alignment_control.dart';
import '../../ui/custom_dropdown.dart';
import '../../ui/custom_slider.dart';
import '../../ui/resizable_text_input.dart';
import '../../ui/text_input.dart';
import '../../utils/custom_observer.dart';
import '../../utils/extensions.dart';

class TimerWidgetSettingsView extends StatelessWidget {
  const TimerWidgetSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.read<WidgetStore>().timerSettings;
    return Column(
      children: [
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Font',
          builder: (context) {
            return CustomDropdown<String>(
              isExpanded: true,
              value: settings.fontFamily,
              items: FontFamilies.fonts,
              onSelected: (family) =>
                  settings.update(() => settings.fontFamily = family),
            );
          },
        ),
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Font size',
          builder: (context) {
            return CustomSlider(
              min: 10,
              max: 400,
              valueLabel: '${settings.fontSize.floor().toString()} px',
              value: settings.fontSize,
              onChanged: (value) => settings
                  .update(() => settings.fontSize = value.floorToDouble()),
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
        LabeledObserver(
          label: 'Format',
          builder: (context) {
            return CustomDropdown<TimerFormat>(
              isExpanded: true,
              value: settings.format,
              items: TimerFormat.values,
              itemBuilder: (context, format) => Text(format.label),
              onSelected: (format) =>
                  settings.update(() => settings.format = format),
            );
          },
        ),
        const SizedBox(height: 16),
        ResizableTextInput(
          label: 'Text Before',
          initialHeight: 50,
          initialValue: settings.textBefore,
          onChanged: (message) => settings.update(
            save: false,
            () => settings.textBefore = message,
          ),
          onSubmitted: (message) =>
              settings.update(() => settings.textBefore = message),
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
                    timer.DateFormat('dd/MM/yyyy').format(settings.time),
                contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                onSubmitted: (value) {
                  if (value.isEmpty || value.length < 10) return false;
                  final parsed = timer.DateFormat('dd/MM/yyyy').parse(value);
                  settings.update(
                    () => settings.time = settings.time.copyWith(
                      day: parsed.day,
                      month: parsed.month,
                      year: parsed.year,
                      hour: settings.time.hour,
                      minute: settings.time.minute,
                      second: 0,
                      millisecond: 0,
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
                initialValue:
                    timer.DateFormat('hh:mm aa').format(settings.time),
                onSubmitted: (value) {
                  if (value.isEmpty || value.length < 5) return false;
                  final tokens = value.split(':');
                  int minutes = int.parse(tokens[1].split(' ')[0]);
                  bool isPM = tokens[1].split(' ')[1] == 'PM';
                  int hours = int.parse(tokens[0]) % (12);
                  if (isPM && hours < 12) hours += 12;
                  settings.update(
                    () => settings.time = settings.time.copyWith(
                      hour: hours,
                      minute: minutes,
                      second: 0,
                      millisecond: 0,
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
          onChanged: (message) => settings.update(
            save: false,
            () => settings.textAfter = message,
          ),
          onSubmitted: (message) =>
              settings.update(() => settings.textAfter = message),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
