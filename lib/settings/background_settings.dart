import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/home_background.dart';
import '../model/color_gradient.dart';
import '../model/flat_color.dart';
import '../resources/color_gradients.dart';
import '../resources/flat_colors.dart';
import '../utils/enums.dart';

class BackgroundSettings extends StatelessWidget {
  const BackgroundSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BackgroundModelBase>(builder: (context, model, child) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomDropdown<BackgroundMode>(
            value: model.mode,
            label: 'Background Mode',
            isExpanded: true,
            items: BackgroundMode.values,
            itemBuilder: (context, item) => Text(item.name),
            onSelected: (mode) => model.setMode(mode),
          ),
          const SizedBox(height: 16),
          if (model.mode.isColor)
            CustomDropdown<FlatColor>(
              value: model.color,
              label: 'Color',
              isExpanded: true,
              items: FlatColors.colors.values.toList(),
              itemBuilder: (context, item) => Text(item.name),
              onSelected: (color) => model.setColor(color),
            ),
          if (model.mode.isGradient)
            CustomDropdown<ColorGradient>(
              value: model.gradient,
              label: 'Gradient',
              isExpanded: true,
              items: ColorGradients.gradients.values.toList(),
              itemBuilder: (context, item) => Text(item.name),
              onSelected: (gradient) => model.setGradient(gradient),
            ),
          const SizedBox(height: 16),
          Slider(
            value: model.tint,
            min: 0,
            max: 100,
            onChanged: (value) => model.setTint(value.roundToDouble()),
          ),
          const SizedBox(height: 32),
        ],
      );
    });
  }
}

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final ValueChanged<T> onSelected;
  final String? label;
  final Widget Function(BuildContext context, T item)? itemBuilder;
  final T? value;
  final bool isExpanded;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.onSelected,
    this.value,
    this.label,
    this.itemBuilder,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) Text(label!),
        if (label != null) const SizedBox(height: 6),
        DropdownButton<T>(
          value: value,
          isExpanded: isExpanded,
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: itemBuilder?.call(context, item) ??
                        Text(item.toString()),
                  ))
              .toList(),
          onChanged: (mode) {
            if (mode == null) return;
            onSelected(mode);
          },
        ),
      ],
    );
  }
}
