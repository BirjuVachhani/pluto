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
