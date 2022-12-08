import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/home_widget.dart';
import '../../model/widget_settings.dart';
import '../../resources/fonts.dart';
import '../../ui/alignment_control.dart';
import '../../ui/custom_dropdown.dart';
import '../../ui/custom_slider.dart';
import '../../utils/utils.dart';

class WeatherWidgetSettingsView extends StatelessWidget {
  const WeatherWidgetSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WidgetModelBase>(
      builder: (context, model, child) {
        final settings = model.weatherSettings;
        return Column(
          children: [
            const SizedBox(height: 16),
            CustomDropdown<String>(
              label: 'Font',
              isExpanded: true,
              value: settings.fontFamily,
              items: FontFamilies.fonts,
              onSelected: (family) => model.updateWeatherSettings(
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
              onChanged: (value) => model.updateWeatherSettings(
                settings.copyWith(fontSize: value.floorToDouble()),
              ),
            ),
            const SizedBox(height: 16),
            AlignmentControl(
              label: 'Position',
              alignment: settings.alignment,
              onChanged: (alignment) => model.updateWeatherSettings(
                settings.copyWith(alignment: alignment),
              ),
            ),
            const SizedBox(height: 16),
            CustomDropdown<WeatherFormat>(
              label: 'Format',
              isExpanded: true,
              value: settings.format,
              items: WeatherFormat.values,
              itemBuilder: (context, item) => Text(item.label),
              onSelected: (format) => model.updateWeatherSettings(
                settings.copyWith(format: format),
              ),
            ),
            const SizedBox(height: 16),
            // TODO: replace with places auto-complete
            CustomDropdown<String>(
              label: 'Location',
              isExpanded: true,
              value: testCities.entries
                  .firstWhereOrNull(
                    (entry) =>
                        entry.value[0] == settings.latitude &&
                        entry.value[1] == settings.longitude,
                  )
                  ?.key,
              items: testCities.keys.toList(),
              onSelected: (city) => model.updateWeatherSettings(
                settings.copyWith(
                  latitude: testCities[city]![0],
                  longitude: testCities[city]![1],
                ),
              ),
            ),
            const SizedBox(height: 16),
            CustomDropdown<TemperatureUnit>(
              label: 'Temperature unit',
              isExpanded: true,
              value: settings.temperatureUnit,
              items: TemperatureUnit.values,
              itemBuilder: (context, item) => Text(item.label),
              onSelected: (unit) => model.updateWeatherSettings(
                settings.copyWith(temperatureUnit: unit),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
