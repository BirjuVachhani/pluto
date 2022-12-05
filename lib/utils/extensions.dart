import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../model/color_gradient.dart';
import '../model/widget_settings.dart';

extension GradientExt on ColorGradient {
  LinearGradient toLinearGradient() {
    return LinearGradient(
      colors: colors,
      begin: begin,
      end: end,
      stops: stops,
    );
  }
}

extension StringExt on String {
  String capitalize() {
    return characters.first.toUpperCase() + substring(1);
  }
}

extension AlignmentExt on AlignmentC {
  Alignment get flutterAlignment {
    switch (this) {
      case AlignmentC.topLeft:
        return Alignment.topLeft;
      case AlignmentC.topCenter:
        return Alignment.topCenter;
      case AlignmentC.topRight:
        return Alignment.topRight;
      case AlignmentC.centerLeft:
        return Alignment.centerLeft;
      case AlignmentC.center:
        return Alignment.center;
      case AlignmentC.centerRight:
        return Alignment.centerRight;
      case AlignmentC.bottomLeft:
        return Alignment.bottomLeft;
      case AlignmentC.bottomCenter:
        return Alignment.bottomCenter;
      case AlignmentC.bottomRight:
        return Alignment.bottomRight;
    }
  }
}

extension ColorFS on Color {
  /// converts a normal [Color] to material color with proper shades mixed
  /// with base color (white).
  MaterialColor toMaterialColor() {
    final strengths = <double>[.05];
    final swatch = <int, Color>{};

    for (var i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (final strength in strengths) {
      final ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        red + ((ds < 0 ? red : (255 - red)) * ds).round(),
        green + ((ds < 0 ? green : (255 - green)) * ds).round(),
        blue + ((ds < 0 ? blue : (255 - blue)) * ds).round(),
        1,
      );
    }
    return MaterialColor(value, swatch);
  }
}
