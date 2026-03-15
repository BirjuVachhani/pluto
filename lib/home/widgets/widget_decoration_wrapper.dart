import 'dart:ui';

import 'package:flutter/material.dart';

import '../../model/widget_settings.dart';

/// Wraps a widget with decoration (background, glass, border),
/// padding, and margin based on common widget settings.
class WidgetDecorationWrapper extends StatelessWidget {
  final WidgetDecoration decoration;
  final double horizontalPadding;
  final double verticalPadding;
  final double horizontalMargin;
  final double verticalMargin;
  final Widget child;

  const WidgetDecorationWrapper({
    super.key,
    required this.decoration,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.horizontalMargin,
    required this.verticalMargin,
    required this.child,
  });

  bool get _hasMargin => horizontalMargin > 0 || verticalMargin > 0;
  bool get _hasPadding => horizontalPadding > 0 || verticalPadding > 0;

  @override
  Widget build(BuildContext context) {
    if (decoration is NoDecoration && !_hasMargin && !_hasPadding) {
      return child;
    }

    Widget result = child;

    // Apply padding inside the decoration.
    if (_hasPadding) {
      result = Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: result,
      );
    }

    // Apply decoration.
    result = switch (decoration) {
      NoDecoration() => result,
      ColorDecoration d => _buildColorDecoration(d, result),
      GlassDecoration d => _buildGlassDecoration(d, result),
      BorderDecoration d => _buildBorderDecoration(d, result),
    };

    // Apply margin outside the decoration.
    if (_hasMargin) {
      result = Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalMargin,
          vertical: verticalMargin,
        ),
        child: result,
      );
    }

    return result;
  }

  Widget _buildColorDecoration(ColorDecoration d, Widget child) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: d.color.withValues(alpha: d.opacity),
        borderRadius: d.borderRadius > 0
            ? BorderRadius.circular(d.borderRadius)
            : null,
      ),
      child: child,
    );
  }

  Widget _buildGlassDecoration(GlassDecoration d, Widget child) {
    return ClipRRect(
      borderRadius: d.borderRadius > 0
          ? BorderRadius.circular(d.borderRadius)
          : BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: d.blur,
          sigmaY: d.blur,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: d.tint.withValues(alpha: d.tintOpacity),
            borderRadius: d.borderRadius > 0
                ? BorderRadius.circular(d.borderRadius)
                : null,
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildBorderDecoration(BorderDecoration d, Widget child) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: d.color.withValues(alpha: d.opacity),
          width: d.thickness,
        ),
        borderRadius: d.borderRadius > 0
            ? BorderRadius.circular(d.borderRadius)
            : null,
      ),
      child: child,
    );
  }
}
