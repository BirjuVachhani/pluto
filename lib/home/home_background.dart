import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../model/background_settings.dart';
import '../model/color_gradient.dart';
import '../model/flat_color.dart';
import '../resources/colors.dart';
import '../resources/storage_keys.dart';
import '../ui/texture_painter.dart';
import '../utils/storage_manager.dart';
import '../utils/utils.dart';

abstract class BackgroundModelBase
    with ChangeNotifier, LazyInitializationMixin {
  late BackgroundSettings settings;

  BackgroundMode get mode => settings.mode;

  FlatColor get color => settings.color;

  ColorGradient get gradient => settings.gradient;

  double get tint => settings.tint;

  bool get texture => settings.texture;

  bool get invert => settings.invert;

  void setMode(BackgroundMode mode);

  void setColor(FlatColor color);

  void setGradient(ColorGradient gradient);

  void setTint(double tint);

  void setTexture(bool texture);

  Color getForegroundColor();
}

class BackgroundModel extends BackgroundModelBase {
  late final StorageManager storage = GetIt.instance.get<StorageManager>();

  @override
  Future<void> init() async {
    final data = await storage.getJson(StorageKeys.backgroundSettings);
    settings =
        data != null ? BackgroundSettings.fromJson(data) : BackgroundSettings();

    initialized = true;
    notifyListeners();
  }

  Future<bool> save() =>
      storage.setJson(StorageKeys.backgroundSettings, settings.toJson());

  @override
  void setMode(BackgroundMode mode) {
    settings = settings.copyWith(mode: mode);
    save();
    notifyListeners();
  }

  @override
  void setColor(FlatColor color) {
    settings = settings.copyWith(color: color);
    save();
    notifyListeners();
  }

  @override
  void setGradient(ColorGradient gradient) {
    settings = settings.copyWith(gradient: gradient);
    save();
    notifyListeners();
  }

  @override
  void setTint(double tint) {
    settings = settings.copyWith(tint: tint);
    save();
    notifyListeners();
  }

  @override
  void setTexture(bool texture) {
    settings = settings.copyWith(texture: texture);
    save();
    notifyListeners();
  }

  @override
  Color getForegroundColor() {
    if (mode.isColor) return color.foreground;
    if (mode.isGradient) return gradient.foreground;
    return Colors.white;
  }
}

class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BackgroundModelBase>(
      builder: (context, model, child) {
        if (!model.initialized) return const SizedBox.shrink();
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            gradient: getBackground(model),
          ),
          foregroundDecoration: BoxDecoration(
            color: AppColors.tint.withOpacity(model.tint / 100),
          ),
          child: model.texture
              ? CustomPaint(
                  painter: TexturePainter(
                    color: model.getForegroundColor().withOpacity(0.4),
                  ),
                  child: child,
                )
              : child,
        );
      },
    );
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
