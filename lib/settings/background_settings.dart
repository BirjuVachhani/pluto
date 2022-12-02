import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/home_background.dart';
import '../model/color_gradient.dart';
import '../model/flat_color.dart';
import '../resources/color_gradients.dart';
import '../resources/flat_colors.dart';
import '../utils/enums.dart';
import '../utils/extensions.dart';

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
          const Text('Background Mode'),
          const SizedBox(height: 10),
          CupertinoTheme(
            data: const CupertinoThemeData(
              primaryContrastingColor: Colors.white,
              primaryColor: Colors.black,
            ),
            child: CupertinoSegmentedControl<BackgroundMode>(
              padding: EdgeInsets.zero,
              groupValue: model.mode,
              selectedColor: Colors.black,
              borderColor: Colors.black,
              onValueChanged: (mode) => model.setMode(mode),
              children: {
                for (final mode in BackgroundMode.values)
                  mode: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(mode.label),
                  ),
              },
            ),
          ),
          // const SizedBox(height: 16),
          // CustomDropdown<BackgroundMode>(
          //   value: model.mode,
          //   label: 'Background Mode',
          //   isExpanded: true,
          //   items: BackgroundMode.values,
          //   itemBuilder: (context, item) => Text(item.label),
          //   onSelected: (mode) => model.setMode(mode),
          // ),
          const SizedBox(height: 16),
          if (model.mode.isColor) ...[
            CustomDropdown<FlatColor>(
              value: model.color,
              label: 'Color',
              isExpanded: true,
              items: FlatColors.colors.values.toList(),
              itemBuilder: (context, item) => Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      shape: const CircleBorder(),
                      color: item.background,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(item.name)),
                ],
              ),
              onSelected: (color) => model.setColor(color),
            ),
            // const SizedBox(height: 16),
            // ColorsGridView(
            //   value: model.color,
            //   items: FlatColors.colors.values.toList(),
            //   onSelected: (color) => model.setColor(color),
            // ),
          ],
          if (model.mode.isGradient) ...[
            CustomDropdown<ColorGradient>(
              value: model.gradient,
              label: 'Gradient',
              isExpanded: true,
              items: ColorGradients.gradients.values.toList(),
              itemBuilder: (context, item) => Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: item.toLinearGradient(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(item.name)),
                ],
              ),
              onSelected: (gradient) => model.setGradient(gradient),
            ),
            // const SizedBox(height: 16),
            // GradientsGridView(
            //   value: model.gradient,
            //   items: ColorGradients.gradients.values.toList(),
            //   onSelected: (gradient) => model.setGradient(gradient),
            // ),
          ],
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
        if (label != null) const SizedBox(height: 10),
        Container(
          color: Colors.grey.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButton<T>(
            value: value,
            isExpanded: isExpanded,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.w400, height: 1),
            underline: const SizedBox.shrink(),
            // dropdownColor: Colors.red,
            menuMaxHeight: 700,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
            ),
            items: items
                .map((item) => DropdownMenuItem<T>(
                      value: item,
                      alignment: Alignment.centerLeft,
                      child: itemBuilder?.call(context, item) ??
                          Text(item.toString()),
                    ))
                .toList(),
            onChanged: (mode) {
              if (mode == null) return;
              onSelected(mode);
            },
          ),
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

class ColorsGridView extends StatelessWidget {
  final List<FlatColor> items;
  final ValueChanged<FlatColor> onSelected;
  final FlatColor? value;

  const ColorsGridView({
    super.key,
    required this.items,
    required this.onSelected,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Colors'),
        GridView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          children: [
            for (final item in items)
              GestureDetector(
                onTap: () => onSelected(item),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      shape: CircleBorder(
                        side: BorderSide(
                          color: Colors.black,
                          // width: 0.5,
                        ),
                      ),
                      color: item.background,
                    ),
                    child: value == item
                        ? Icon(Icons.done, color: item.foreground)
                        : null,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class GradientsGridView extends StatelessWidget {
  final List<ColorGradient> items;
  final ValueChanged<ColorGradient> onSelected;
  final ColorGradient? value;

  const GradientsGridView({
    super.key,
    required this.items,
    required this.onSelected,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Gradients'),
        GridView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          children: [
            for (final item in items)
              GestureDetector(
                onTap: () => onSelected(item),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        // width: 0.5,
                      ),
                      gradient: item.toLinearGradient(),
                    ),
                    child: value == item
                        ? Icon(Icons.done, color: item.foreground)
                        : null,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
