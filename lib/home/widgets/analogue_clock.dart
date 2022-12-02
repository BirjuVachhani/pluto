import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../ui/analogue_clock_painter.dart';

class AnalogueClock extends StatefulWidget {
  final double radius;
  final Color? color;

  const AnalogueClock({super.key, required this.radius, this.color});

  @override
  State<AnalogueClock> createState() => _AnalogueClockState();
}

class _AnalogueClockState extends State<AnalogueClock>
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
      if (_now.second != newTime.second) {
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
        painter: AnalogueClockPainter(
          time: _now,
          color: widget.color,
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
