import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/widget_store.dart';
import '../../model/widget_settings.dart';
import '../../resources/fonts.dart';
import '../../ui/alignment_control.dart';
import '../../ui/custom_dropdown.dart';
import '../../ui/custom_slider.dart';
import '../../utils/custom_observer.dart';
import '../../utils/extensions.dart';

class DigitalClockWidgetSettingsView extends StatelessWidget {
  const DigitalClockWidgetSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.read<WidgetStore>().digitalClockSettings;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
              onChanged: (value) => settings.update(
                () => settings.fontSize = value.floorToDouble(),
              ),
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
          label: 'Border',
          builder: (context) {
            return CustomDropdown<BorderType>(
              isExpanded: true,
              value: settings.borderType,
              items: BorderType.values,
              itemBuilder: (context, type) => Text(type.name.capitalize()),
              onSelected: (value) =>
                  settings.update(() => settings.borderType = value),
            );
          },
        ),
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Separator',
          builder: (context) {
            return CustomDropdown<Separator>(
              isExpanded: true,
              value: settings.separator,
              items: Separator.values,
              itemBuilder: (context, type) => Text(type.name.capitalize()),
              onSelected: (value) =>
                  settings.update(() => settings.separator = value),
            );
          },
        ),
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Format',
          builder: (context) {
            return CustomDropdown<ClockFormat>(
              isExpanded: true,
              value: settings.format,
              items: ClockFormat.values,
              itemBuilder: (context, type) => Text(type.label),
              onSelected: (value) =>
                  settings.update(() => settings.format = value),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
