import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DigitalClock extends StatefulWidget {
  final String separator;
  final TextStyle? style;
  final Decoration? decoration;
  final EdgeInsets? padding;

  const DigitalClock({
    super.key,
    this.separator = ':',
    this.style,
    this.decoration,
    this.padding,
  });

  @override
  State<DigitalClock> createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock>
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
    return DigitalClockRenderer(
      time: _now,
      style: widget.style,
      separator: widget.separator,
      decoration: widget.decoration,
      padding: widget.padding,
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}

class DigitalClockRenderer extends StatelessWidget {
  final DateTime time;
  final TextStyle? style;
  final String separator;
  final Decoration? decoration;
  final EdgeInsets? padding;

  const DigitalClockRenderer({
    super.key,
    required this.time,
    this.separator = ':',
    this.style,
    this.decoration,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: decoration ?? const BoxDecoration(),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Text(
          '${time.hour.toString().padLeft(2, '0')}$separator${time.minute.toString().padLeft(2, '0')}',
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );
  }
}
