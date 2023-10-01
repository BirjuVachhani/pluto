import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class DigitalDate extends StatefulWidget {
  final TextStyle? style;
  final Decoration? decoration;
  final EdgeInsets? padding;
  final String format;

  const DigitalDate({
    super.key,
    this.style,
    this.decoration,
    this.padding,
    this.format = 'MMMM dd, yyyy',
  });

  @override
  State<DigitalDate> createState() => _DigitalDateState();
}

class _DigitalDateState extends State<DigitalDate>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late DateTime _initialDate;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _initialDate = _now = DateTime.now();
    _ticker = createTicker((elapsed) {
      final newDate = _initialDate.add(elapsed);
      // Rebuild only if the date changes instead of every frame
      if (!_areDatesEqual(_now, newDate)) {
        setState(() => _now = newDate);
      }
    });
    _ticker.start();
  }

  bool _areDatesEqual(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return _DigitalDateRenderer(
      date: _now,
      style: widget.style,
      decoration: widget.decoration,
      padding: widget.padding,
      format: widget.format,
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}

class _DigitalDateRenderer extends StatelessWidget {
  final DateTime date;
  final TextStyle? style;
  final Decoration? decoration;
  final EdgeInsets? padding;
  final String format;

  const _DigitalDateRenderer({
    required this.date,
    this.style,
    this.decoration,
    this.padding,
    this.format = 'MMMM dd, yyyy',
  });

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat(format).format(date);
    return DecoratedBox(
      decoration: decoration ?? const BoxDecoration(),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Text(
          dateString,
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );
  }
}
