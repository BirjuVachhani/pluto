import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../model/color_gradient.dart';
import '../model/flat_color.dart';
import '../model/widget_settings.dart';
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
const List<Location> testCities = [
  Location(
    name: 'Rajkot, India',
    latitude: 22.3039,
    longitude: 70.8022,
  ),
  Location(
    name: 'Delhi, India',
    latitude: 28.7041,
    longitude: 77.1025,
  ),
  Location(
    name: 'Tokyo, Japan',
    latitude: 35.6762,
    longitude: 139.6503,
  ),
  Location(
    name: 'New York, USA',
    latitude: 40.7128,
    longitude: -74.0060,
  ),
  Location(
    name: 'Chicago, USA',
    latitude: 41.8781,
    longitude: -87.6298,
  ),
  Location(
    name: 'Ahmedabad, India',
    latitude: 23.0225,
    longitude: 72.5714,
  ),
  Location(
    name: 'Manali, India',
    latitude: 32.2432,
    longitude: 77.1892,
  ),
  Location(
    name: 'Mumbai, India',
    latitude: 19.0760,
    longitude: 72.8777,
  ),
  Location(
    name: 'San Francisco, USA',
    latitude: 37.7749,
    longitude: 122.4194,
  ),
  Location(
    name: 'Amsterdam, Netherlands',
    latitude: 52.3676,
    longitude: 4.9041,
  ),
];
