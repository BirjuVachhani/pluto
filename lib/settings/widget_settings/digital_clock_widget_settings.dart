import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/home_widget.dart';
import '../../model/widget_settings.dart';
import '../../resources/fonts.dart';
import '../../ui/alignment_control.dart';
import '../../ui/custom_dropdown.dart';
import '../../ui/custom_slider.dart';
import '../../utils/extensions.dart';

class DigitalClockWidgetSettingsView extends StatelessWidget {
  const DigitalClockWidgetSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WidgetModelBase>(
      builder: (context, model, child) {
        final settings = model.digitalClockSettings;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            CustomDropdown<String>(
              label: 'Font',
              isExpanded: true,
              value: settings.fontFamily,
              items: FontFamilies.fonts,
              onSelected: (family) => model.updateDigitalClockSettings(
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
              onChanged: (value) => model.updateDigitalClockSettings(
                settings.copyWith(fontSize: value.floorToDouble()),
              ),
            ),
            const SizedBox(height: 16),
            AlignmentControl(
              label: 'Position',
              alignment: settings.alignment,
              onChanged: (alignment) => model.updateDigitalClockSettings(
                settings.copyWith(alignment: alignment),
              ),
            ),
            const SizedBox(height: 16),
            CustomDropdown<BorderType>(
              label: 'Border',
              isExpanded: true,
              value: settings.borderType,
              items: BorderType.values,
              itemBuilder: (context, type) => Text(type.name.capitalize()),
              onSelected: (value) => model.updateDigitalClockSettings(
                settings.copyWith(borderType: value),
              ),
            ),
            const SizedBox(height: 16),
            CustomDropdown<Separator>(
              label: 'Separator',
              isExpanded: true,
              value: settings.separator,
              items: Separator.values,
              itemBuilder: (context, type) => Text(type.name.capitalize()),
              onSelected: (value) => model.updateDigitalClockSettings(
                settings.copyWith(separator: value),
              ),
            ),
            const SizedBox(height: 16),
            CustomDropdown<ClockFormat>(
              label: 'Format',
              isExpanded: true,
              value: settings.format,
              items: ClockFormat.values,
              itemBuilder: (context, type) => Text(type.label),
              onSelected: (value) => model.updateDigitalClockSettings(
                settings.copyWith(format: value),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
