import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/home_widget.dart';
import '../../resources/fonts.dart';
import '../../ui/alignment_control.dart';
import '../../ui/custom_dropdown.dart';
import '../../ui/custom_slider.dart';
import '../../ui/resizable_text_input.dart';

class MessageWidgetSettingsView extends StatelessWidget {
  const MessageWidgetSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WidgetModelBase>(
      builder: (context, model, child) {
        final settings = model.messageSettings;
        return Column(
          children: [
            const SizedBox(height: 16),
            CustomDropdown<String>(
              label: 'Font',
              isExpanded: true,
              value: settings.fontFamily,
              items: FontFamilies.fonts,
              onSelected: (family) => model.updateMessageSettings(
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
              onChanged: (value) => model.updateMessageSettings(
                settings.copyWith(fontSize: value.floorToDouble()),
              ),
            ),
            const SizedBox(height: 16),
            AlignmentControl(
              label: 'Position',
              alignment: settings.alignment,
              onChanged: (alignment) => model.updateMessageSettings(
                settings.copyWith(alignment: alignment),
              ),
            ),
            const SizedBox(height: 16),
            ResizableTextInput(
              label: 'Message',
              initialValue: settings.message,
              onChanged: (message) => model.updateMessageSettings(
                settings.copyWith(message: message),
                save: false,
              ),
              onSubmitted: (message) => model.updateMessageSettings(
                settings.copyWith(message: message),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
