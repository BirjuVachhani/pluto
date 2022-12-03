import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AnalogClock extends StatefulWidget {
  final double radius;
  final Color? color;
  final bool showSecondsHand;
  final Color? secondHandColor;

  const AnalogClock({
    super.key,
    required this.radius,
    this.color,
    this.showSecondsHand = true,
    this.secondHandColor,
  });

  @override
  State<AnalogClock> createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late DateTime _initialTime;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _initialTime = _now = DateTime.now();
    _ticker = createTicker((elapsed) {
      final newTime = _initialTime.add(elapsed);
      // rebuild only if seconds changes instead of every frame
      if (_now.second != newTime.second && widget.showSecondsHand) {
        setState(() => _now = newTime);
      } else if (_now.minute != newTime.minute) {
        setState(() => _now = newTime);
      }
    });
    _ticker.start();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.radius * 2,
      child: CustomPaint(
        painter: AnalogClockPainter(
          time: _now,
          color: widget.color,
          secondHandColor: widget.secondHandColor,
          showSecondHand: widget.showSecondsHand,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}

/// If [color] is provided then it will be used to paint everything.
class AnalogClockPainter extends CustomPainter {
  final DateTime time;
  final Color? dialColor;
  final Color? hourHandColor;
  final Color? minuteHandColor;
  final Color? secondHandColor;
  final bool showSecondHand;
  final Color? color;
  final double secondHandThickness;
  final double minuteHandThickness;
  final double hourHandThickness;
  final double dialThickness;

  static const double angleAtNoon = -pi / 2; // in radians.
  static const double angleOfASecond = 2 * pi / 60; // in radians.
  static const double angleOfAMinute = 2 * pi / 60; // in radians.
  static const double angleOfAnHour = 2 * pi / 12; // in radians.

  AnalogClockPainter({
    required this.time,
    this.color,
    this.dialColor,
    this.hourHandColor,
    this.minuteHandColor,
    this.secondHandColor,
    this.showSecondHand = true,
    this.secondHandThickness = 2,
    this.minuteHandThickness = 4,
    this.hourHandThickness = 6,
    this.dialThickness = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Radius is calculated such that everything won't leak outside the viewport.
    final rect = Rect.fromCircle(
        center: center,
        radius: min(size.width, size.height) / 2 - dialThickness);

    _drawDial(canvas, rect, center);
    _drawHourHand(canvas, rect, center);
    _drawMinuteHand(canvas, rect, center);
    if (showSecondHand) _drawSecondHand(canvas, rect, center);
  }

  void _drawDial(Canvas canvas, Rect rect, Offset center) {
    // paint radius.
    final dialRadius = rect.center.dx + dialThickness / 2;

    final Paint dialPaint = Paint()
      ..color = dialColor ?? color ?? Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = dialThickness;

    // paint the dialer
    canvas.drawCircle(center, dialRadius, dialPaint);
  }

  void _drawSecondHand(Canvas canvas, Rect rect, Offset center) {
    final double radius = (rect.width / 2 * 0.9) - (secondHandThickness / 2);

    final Paint paint = Paint()
      ..color = secondHandColor ?? color?.withOpacity(0.4) ?? Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = secondHandThickness;

    // we add 1 second to the current time because we paint the second after
    // it has passed.
    final double angle = angleAtNoon + angleOfASecond * (time.second + 1);

    final double x = center.dx + (radius * cos(angle));
    final double y = center.dy + (radius * sin(angle));

    canvas.drawLine(center, Offset(x, y), paint);
  }

  void _drawMinuteHand(Canvas canvas, Rect rect, Offset center) {
    final sizePercent = showSecondHand ? 0.8 : 0.85;
    final double radius =
        (rect.width / 2 * sizePercent) - (minuteHandThickness / 2);

    final Paint paint = Paint()
      ..color = minuteHandColor ?? color?.withOpacity(0.6) ?? Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = minuteHandThickness;

    final double angle = angleAtNoon + angleOfAMinute * time.minute;

    final double x = center.dx + (radius * cos(angle));
    final double y = center.dy + (radius * sin(angle));

    canvas.drawLine(center, Offset(x, y), paint);
  }

  void _drawHourHand(Canvas canvas, Rect innerRect, Offset center) {
    final sizePercent = showSecondHand ? 0.6 : 0.65;
    final double radius =
        (innerRect.width / 2 * sizePercent) - (hourHandThickness / 2);

    final Paint paint = Paint()
      ..color = hourHandColor ?? color?.withOpacity(1) ?? Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = hourHandThickness;

    final double angle = angleAtNoon + angleOfAnHour * time.hour;

    final double x = center.dx + (radius * cos(angle));
    final double y = center.dy + (radius * sin(angle));

    canvas.drawLine(center, Offset(x, y), paint);
  }

  @override
  bool shouldRepaint(covariant AnalogClockPainter oldDelegate) =>
      oldDelegate.time != time ||
      oldDelegate.color != color ||
      oldDelegate.dialColor != dialColor ||
      oldDelegate.hourHandColor != hourHandColor ||
      oldDelegate.minuteHandColor != minuteHandColor ||
      oldDelegate.secondHandColor != secondHandColor ||
      oldDelegate.showSecondHand != showSecondHand ||
      oldDelegate.secondHandThickness != secondHandThickness ||
      oldDelegate.minuteHandThickness != minuteHandThickness ||
      oldDelegate.hourHandThickness != hourHandThickness ||
      oldDelegate.dialThickness != dialThickness;
}
