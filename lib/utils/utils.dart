import '../model/color_gradient.dart';
import '../model/flat_color.dart';
import '../resources/color_gradients.dart';
import '../resources/flat_colors.dart';

ColorGradient? findGradientByName(String name) => ColorGradients.gradients[name];

FlatColor? findColorByName(String name) => FlatColors.colors[name];