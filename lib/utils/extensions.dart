import 'package:flutter/painting.dart';
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
