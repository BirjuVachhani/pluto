import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/widget_store.dart';
import '../../model/widget_settings.dart';
import '../../resources/fonts.dart';
import '../../ui/alignment_control.dart';
import '../../ui/custom_dropdown.dart';
import '../../ui/custom_slider.dart';
import '../../ui/resizable_text_input.dart';
import '../../utils/custom_observer.dart';
import '../../utils/extensions.dart';
import 'settings_section_header.dart';

class DigitalDateWidgetSettingsView extends StatefulWidget {
  const DigitalDateWidgetSettingsView({super.key});

  @override
  State<DigitalDateWidgetSettingsView> createState() => _DigitalDateWidgetSettingsViewState();
}

class _DigitalDateWidgetSettingsViewState extends State<DigitalDateWidgetSettingsView> {
  @override
  Widget build(BuildContext context) {
    final settings = context.read<WidgetStore>().digitalDateSettings;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        const SettingsSectionHeader(title: 'Typography'),
        const SizedBox(height: 12),
        LabeledObserver(
          label: 'Font',
          builder: (context) {
            return CustomDropdown<String>(
              isExpanded: true,
              value: settings.fontFamily,
              items: FontFamilies.fonts,
              itemBuilder: (context, family) => Text(
                family,
                style: TextStyle(fontFamily: family),
              ),
              selectedItemBuilder: (context, family) => Text(
                family,
                style: TextStyle(fontFamily: family),
              ),
              onSelected: (family) {
                settings.update(() => settings.fontFamily = family);
              },
            );
          },
        ),
        const SizedBox(height: 10),
        LabeledObserver(
          label: 'Size',
          builder: (context) {
            return CustomSlider(
              min: 10,
              max: 400,
              valueLabel: '${settings.fontSize.floor()} px',
              value: settings.fontSize,
              onChanged: (value) {
                settings.update(
                  () => settings.fontSize = value.floorToDouble(),
                );
              },
            );
          },
        ),
        const SizedBox(height: 20),
        const SettingsSectionHeader(title: 'Layout'),
        const SizedBox(height: 12),
        LabeledObserver(
          label: 'Position',
          builder: (context) {
            return AlignmentControl(
              alignment: settings.alignment,
              onChanged: (alignment) {
                settings.update(() => settings.alignment = alignment);
              },
            );
          },
        ),
        const SizedBox(height: 20),
        const SettingsSectionHeader(title: 'Display'),
        const SizedBox(height: 12),
        LabeledObserver(
          label: 'Separator',
          builder: (context) {
            return CustomDropdown<DateSeparator>(
              isExpanded: true,
              value: settings.separator,
              items: DateSeparator.values,
              itemBuilder: (context, type) => Text(type.name.capitalize()),
              onSelected: (value) {
                settings.update(() => settings.separator = value);
                setState(() {});
              },
            );
          },
        ),
        const SizedBox(height: 10),
        LabeledObserver(
          label: 'Date format',
          builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomDropdown<DateFormat>(
                  isExpanded: true,
                  value: settings.format,
                  items: DateFormat.values,
                  itemBuilder: (context, type) => Text(type.prettify(settings.separator.value)),
                  onSelected: (value) => settings.update(() => settings.format = value),
                ),
                if (settings.format == DateFormat.custom) ...[
                  const SizedBox(height: 10),
                  ResizableTextInput(
                    label: 'Template',
                    initialHeight: 50,
                    initialValue: settings.customFormat,
                    onChanged: (value) => settings.update(
                      save: false,
                      () => setState(() {
                        settings.customFormat = value;
                      }),
                    ),
                    onSubmitted: (value) => settings.update(
                      () => settings.customFormat = value,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
