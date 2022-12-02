import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../model/color_gradient.dart';
import '../model/flat_color.dart';
import '../resources/color_gradients.dart';
import '../resources/colors.dart';
import '../resources/flat_colors.dart';
import '../resources/storage_keys.dart';
import '../utils/enums.dart';
import '../utils/storage_manager.dart';
import '../utils/utils.dart';

abstract class BackgroundModelBase with ChangeNotifier {
  BackgroundMode mode = BackgroundMode.flat;
  FlatColor color = FlatColors.colors.values.first;
  ColorGradient gradient = ColorGradients.gradients.values.first;
  double tint = 0;

  void init();

  void setMode(BackgroundMode mode);

  void setColor(FlatColor color);

  void setGradient(ColorGradient gradient);

  void setTint(double tint);
}

class BackgroundModel extends BackgroundModelBase {
  late final StorageManager storage = GetIt.instance.get<StorageManager>();

  BackgroundModel() {
    init();
  }

  @override
  void init() async {
    mode = await storage.getEnum<BackgroundMode>(
            StorageKeys.backgroundMode, BackgroundMode.values) ??
        BackgroundMode.flat;

    color = findColorByName(
            await storage.getString(StorageKeys.backgroundColor) ?? '') ??
        FlatColors.colors.values.first;

    gradient = findGradientByName(
            await storage.getString(StorageKeys.backgroundGradient) ?? '') ??
        ColorGradients.gradients.values.first;

    tint = await storage.getDouble(StorageKeys.tint) ?? 0;

    notifyListeners();
  }

  @override
  void setMode(BackgroundMode mode) {
    this.mode = mode;
    storage.setEnum(StorageKeys.backgroundMode, mode);
    notifyListeners();
  }

  @override
  void setColor(FlatColor color) {
    this.color = color;
    storage.setString(StorageKeys.backgroundColor, color.name);
    notifyListeners();
  }

  @override
  void setGradient(ColorGradient gradient) {
    this.gradient = gradient;
    storage.setString(StorageKeys.backgroundGradient, gradient.name);
    notifyListeners();
  }

  @override
  void setTint(double tint) {
    this.tint = tint;
    storage.setDouble(StorageKeys.tint, tint);
    notifyListeners();
  }
}

class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BackgroundModelBase>(builder: (context, model, child) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          gradient: getBackground(model),
        ),
        foregroundDecoration: BoxDecoration(
          color: AppColors.tint.withOpacity(model.tint / 100),
        ),
      );
    });
  }

  Color? getBackgroundColor(BackgroundModelBase model) {
    if (!model.mode.isColor) return null;
    return model.color.background;
  }

  LinearGradient? getBackground(BackgroundModelBase model) {
    if (model.mode.isImage) return null;
    final gradient = model.gradient;

    final colors = model.mode.isGradient
        ? gradient.colors
        : [model.color.background, model.color.background];

    return LinearGradient(
      colors: colors,
      begin: gradient.begin,
      end: gradient.end,
      stops: model.mode.isGradient ? gradient.stops : null,
    );
  }
}
