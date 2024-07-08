import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../model/background_settings.dart';
import '../model/color_gradient.dart';
import '../model/flat_color.dart';
import '../resources/color_gradients.dart';
import '../resources/flat_colors.dart';
import 'extensions.dart';

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

Uri applyResolutionOnUrl(String url, ImageResolution? resolution) {
  final Size? size =
      resolution == ImageResolution.original ? null : resolution?.toSize();

  final uri = Uri.parse(url);
  if (resolution == ImageResolution.original) {
    return Uri(
      scheme: uri.scheme,
      host: uri.host,
      path: uri.path,
    );
  }
  return Uri(
    scheme: uri.scheme,
    host: uri.host,
    path: uri.path,
    queryParameters: {
      ...uri.queryParameters,
      if (size != null) ...{
        'q': '100',
        'w': size.width.toStringAsFixed(0),
        'h': size.height.toStringAsFixed(0),
      },
    },
  );
}

Future<Uint8List> takeScreenshot(
  GlobalKey widgetKey, {
  double devicePixelRatio = 1,
  ui.ImageByteFormat format = ui.ImageByteFormat.png,
}) async {
  try {
    final RenderObject renderObject =
        widgetKey.currentContext?.findRenderObject() ??
            (throw ScreenshotException('No RenderObject found'));
    if (renderObject is! RenderRepaintBoundary) {
      throw ScreenshotException('RenderObject is not a RenderRepaintBoundary');
    }

    final ui.Image image =
        await renderObject.toImage(pixelRatio: devicePixelRatio);
    // image to Uint8List
    final ByteData? byteData = await image.toByteData(format: format);
    if (byteData == null) {
      throw ScreenshotException(
          'Error while taking screenshot: byteData is null');
    }
    final Uint8List pngBytes = byteData.buffer.asUint8List();

    return pngBytes;
  } on ScreenshotException {
    rethrow;
  } catch (error) {
    throw ScreenshotException('Error while taking screenshot: $error');
  }
}

class ScreenshotException implements Exception {
  final String? message;

  ScreenshotException([this.message]);

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return 'Exception';
    return 'ScreenshotException: $message';
  }
}
