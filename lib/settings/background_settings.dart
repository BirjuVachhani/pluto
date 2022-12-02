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
          const Text('Tint'),
          const SizedBox(height: 12),
          SliderTheme(
            data: const SliderThemeData(
              thumbShape: RectangleThumbShape(),
              overlayColor: Colors.red,
              thumbColor: Colors.red,
              overlayShape: RectangleThumbShape(),
              trackHeight: 2,
            ),
            child: Slider(
              value: model.tint,
              min: 0,
              max: 100,
              activeColor: Colors.black,
              inactiveColor: Colors.black.withOpacity(0.1),
              onChanged: (value) => model.setTint(value.roundToDouble()),
            ),
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

class RectangleThumbShape extends SliderComponentShape {
  final double width;
  final double height;

  const RectangleThumbShape({this.width = 10, this.height = 22});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size(width, height);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    assert(sliderTheme.thumbColor != null);

    final Canvas canvas = context.canvas;
    final topLeft = center.translate(-width / 2, -height / 2);
    canvas.drawRect(topLeft & Size(width, height),
        Paint()..color = sliderTheme.thumbColor!);
  }
}
