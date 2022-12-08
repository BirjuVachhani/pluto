import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../model/color_gradient.dart';
import '../model/flat_color.dart';
import '../resources/color_gradients.dart';
import '../resources/flat_colors.dart';

/// Finds a [ColorGradient] by its [name] from the [ColorGradients] list.
ColorGradient? findGradientByName(String name) =>
    ColorGradients.gradients[name];

/// Finds a color by [name] from the [FlatColors] list.
FlatColor? findColorByName(String name) => FlatColors.colors[name];

mixin LazyInitializationMixin on ChangeNotifier {
  bool initialized = false;

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

// TODO: replace with places auto-complete
const Map<String, List<double>> testCities = {
  'Rajkot, India': [22.3039, 70.8022],
  'Delhi, India': [28.7041, 77.1025],
  'Tokyo, Japan': [35.6762, 139.6503],
  'New York, USA': [40.7128, -74.0060],
  'Chicago, USA': [41.8781, -87.6298],
  'Ahmedabad, India': [23.0225, 72.5714],
  'Manali, India': [32.2432, 77.1892],
  'Mumbai, India': [19.0760, 72.8777],
  'San Francisco, USA': [37.7749, 122.4194],
  'Amsterdam, Netherlands': [52.3676, 4.9041],
};
