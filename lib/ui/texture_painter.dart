import 'package:flutter/widgets.dart';

/// A painter that paints a grid with dots.
/// [color] defines color of the dots.
/// [Spacing] defines space between two dot centers. Simply distance between
/// 2 dots.
/// [radius] defines the radius of a dot.
/// [offset] defines from where to start printing the grid.
///
/// Note that this painter must only be used in a constrained area.
/// Meaning, either the parent must have a finite size or the painter must be
/// provided with a finite size otherwise the painter will throw an exception.
class TexturePainter extends CustomPainter {
  final Color color;
  final double spacing;
  final double offset;
  final double radius;

  TexturePainter({
    required this.color,
    this.spacing = 30,
    this.offset = 16,
    this.radius = 1,
  })  : assert(spacing > 0 && spacing < double.infinity),
        assert(radius >= 0 && radius <= double.infinity);

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width - offset;
    final double height = size.height - offset;

    assert(width > 0 && height > 0);
    assert(width < double.infinity && height < double.infinity);

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Calculate the number of dots that can fit in the width and height.
    final int horizontalCount = (width / spacing).ceil();
    final int verticalCount = (height / spacing).ceil();

    for (int line = 0; line < verticalCount; line++) {
      for (int column = 0; column < horizontalCount; column++) {
        final double x = (column * spacing) + offset;
        final double y = (line * spacing) + offset;

        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant TexturePainter oldDelegate) =>
      oldDelegate.radius != radius ||
      oldDelegate.spacing != spacing ||
      oldDelegate.color != color ||
      oldDelegate.offset != offset;
}
