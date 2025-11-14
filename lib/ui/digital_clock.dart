import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticking_widget/ticking_widget.dart';

class DigitalClock extends StatelessWidget {
  final TextStyle? style;
  final Decoration? decoration;
  final EdgeInsets? padding;
  final String format;

  const DigitalClock({
    super.key,
    this.style,
    this.decoration,
    this.padding,
    this.format = 'hh:mm',
  });

  @override
  Widget build(BuildContext context) {
    return TickingWidget(
      mode: TickingMode.second,
      builder: (context, now, child) {
        return _DigitalClockRenderer(
          time: now,
          style: style,
          decoration: decoration,
          padding: padding,
          format: format,
        );
      },
    );
  }
}

class _DigitalClockRenderer extends StatelessWidget {
  final DateTime time;
  final TextStyle? style;
  final Decoration? decoration;
  final EdgeInsets? padding;
  final String format;

  const _DigitalClockRenderer({
    required this.time,
    this.style,
    this.decoration,
    this.padding,
    this.format = 'hh:mm',
  });

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat(format).format(time);
    return DecoratedBox(
      decoration: decoration ?? const BoxDecoration(),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Text(
          timeString,
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );
  }
}
