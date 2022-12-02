import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import '../model/color_gradient.dart';

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
