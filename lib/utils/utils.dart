import 'dart:ui';

import '../model/color_gradient.dart';
import '../model/flat_color.dart';
import '../resources/color_gradients.dart';
import '../resources/flat_colors.dart';

/// Finds a [ColorGradient] by its [name] from the [ColorGradients] list.
ColorGradient? findGradientByName(String name) =>
    ColorGradients.gradients[name];

/// Finds a color by [name] from the [FlatColors] list.
FlatColor? findColorByName(String name) => FlatColors.colors[name];

mixin LazyInitializationMixin {
  Future<void> init();
}

/// A greyscale filter for images(or pretty much anything!).
ColorFilter greyscale([double value = 1]) {
  assert(value >= 0 && value <= 1);
  if (value == 0) {
    return const ColorFilter.matrix([
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]);
  }
  return ColorFilter.matrix(<double>[
    lerpDouble(1, 0.2126, value)!,
    lerpDouble(0, 0.7152, value)!,
    lerpDouble(0, 0.0722, value)!,
    0,
    0,
    lerpDouble(0, 0.2126, value)!,
    lerpDouble(1, 0.7152, value)!,
    lerpDouble(0, 0.0722, value)!,
    0,
    0,
    lerpDouble(0, 0.2126, value)!,
    lerpDouble(0, 0.7152, value)!,
    lerpDouble(1, 0.0722, value)!,
    0,
    0,
    0,
    0,
    0,
    value,
    0,
  ]);
}
