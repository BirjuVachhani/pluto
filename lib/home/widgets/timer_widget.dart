import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';
import 'package:screwdriver/screwdriver.dart';

import '../../model/widget_settings.dart';
import '../../utils/custom_observer.dart';
import '../../utils/extensions.dart';
import '../background_store.dart';
import '../widget_store.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late DateTime _initialTime;
  late DateTime _now;

  late final WidgetStore store = context.read<WidgetStore>();

  @override
  void initState() {
    super.initState();
    _initialTime = _now = DateTime.now();
    _ticker = createTicker((elapsed) {
      final newTime = _initialTime.add(elapsed);
      // rebuild only if seconds changes instead of every frame
      if (store.timerSettings.format.showsSeconds &&
          _now.second != newTime.second) {
        setState(() => _now = newTime);
      } else if (_now.minute != newTime.minute) {
        setState(() => _now = newTime);
      }
    });
    _ticker.start();
  }

  @override
  Widget build(BuildContext context) {
    final BackgroundStore backgroundStore = context.read<BackgroundStore>();
    final settings = store.timerSettings;

    return CustomObserver(
      name: 'TimerWidget',
      builder: (context) {
        final hasFixedWidth = settings.textBefore.isEmpty &&
            settings.textAfter.isEmpty &&
            settings.format == TimerFormat.countdown;

        Widget wid = Text.rich(
          buildTimerTextSpan(settings),
          textAlign: settings.alignment.textAlign,
          style: TextStyle(
            color: backgroundStore.foregroundColor,
            fontSize: settings.fontSize,
            fontFamily: settings.fontFamily,
            height: 1.4,
            letterSpacing: 0.2,
          ),
        );
        if (hasFixedWidth) {
          final style = TextStyle(
            color: backgroundStore.foregroundColor,
            fontSize: settings.fontSize,
            fontFamily: settings.fontFamily,
            height: 1.4,
            letterSpacing: 0.2,
          );
          wid = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final char in buildTime(settings).split(''))
                SizedBox(
                  width: char == ':'
                      ? settings.fontSize * 0.3
                      : settings.fontSize * 0.6,
                  child: Text(
                    char,
                    textAlign: settings.alignment.textAlign,
                    style: style,
                  ),
                ),
            ],
          );
        }

        return Align(
          alignment: settings.alignment.flutterAlignment,
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(56),
              child: wid,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  InlineSpan buildTimerTextSpan(TimerWidgetSettingsStore settings) {
    return TextSpan(text: settings.textBefore, children: [
      TextSpan(
        text: buildTime(settings),
        style: TextStyle(
          letterSpacing: settings.format == TimerFormat.countdown ? 2 : null,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
      TextSpan(text: settings.textAfter),
    ]);
  }

  String buildTime(TimerWidgetSettingsStore settings) {
    final Duration duration = DateTime.now() >= settings.time
        ? DateTime.now().difference(settings.time)
        : settings.time.difference(DateTime.now());
    final StringBuffer buffer = StringBuffer();
    switch (settings.format) {
      case TimerFormat.seconds:
        buffer.write(
          Intl.plural(
            duration.inSeconds,
            one: 'a second',
            other: '${formatAsNumber(duration.inSeconds)} seconds',
          ),
        );
        break;
      case TimerFormat.minutes:
        buffer.write(
          Intl.plural(
            duration.inMinutes,
            zero: 'less than a minute',
            one: 'a minute',
            other: '${formatAsNumber(duration.inMinutes)} minutes',
          ),
        );
        break;
      case TimerFormat.hours:
        buffer.write(
          Intl.plural(
            duration.inHours,
            zero: 'less than an hour',
            one: 'an hour',
            other: '${formatAsNumber(duration.inHours)} hours',
          ),
        );
        break;
      case TimerFormat.days:
        buffer.write(
          Intl.plural(
            duration.inDays,
            zero: 'less than a day',
            one: 'a day',
            other: '${formatAsNumber(duration.inDays)} days',
          ),
        );
        break;
      case TimerFormat.countdown:
        buffer.write(
          '${duration.inHours.toString().padLeft(2, '0')}:'
          '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
          '${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
        );
        break;
      case TimerFormat.years:
        int years = (settings.time.year - DateTime.now().year).abs();
        if (years > 0) {
          if (DateTime.now() >= settings.time) {
            // past timer.
            if (DateTime.now() <
                DateTime(DateTime.now().year, settings.time.month,
                    settings.time.day)) {
              years--;
            }
          } else {
            // future timer.
            if (DateTime.now() >
                DateTime(DateTime.now().year, settings.time.month,
                    settings.time.day)) {
              years--;
            }
          }
        }
        buffer.write(
          Intl.plural(
            years,
            zero: 'less than a year',
            one: 'a year',
            other: '${formatAsNumber(years)} years',
          ),
        );
        break;
      case TimerFormat.descriptive:
      case TimerFormat.descriptiveWithSeconds:
        int seconds = duration.inSeconds;
        int minutes = seconds ~/ 60;
        int hours = minutes ~/ 60;
        int days = hours ~/ 24;
        int years = days ~/ 365;

        days = days - years * 365;
        hours = hours - days * 24 - years * 365 * 24;
        minutes = minutes - days * 24 * 60 - hours * 60 - years * 365 * 24 * 60;
        seconds = seconds -
            days * 24 * 60 * 60 -
            hours * 60 * 60 -
            minutes * 60 -
            years * 365 * 24 * 60 * 60;
        if (years > 0) {
          buffer
              .write('${formatAsNumber(years)} ${fixGrammar(years, 'year')} ');
        }
        if (days > 0) {
          buffer.write('${formatAsNumber(days)} ${fixGrammar(days, 'day')} ');
        }
        if (hours > 0) {
          buffer
              .write('${formatAsNumber(hours)} ${fixGrammar(hours, 'hour')} ');
        }
        if (minutes > 0) {
          buffer.write(
              '${formatAsNumber(minutes)} ${fixGrammar(minutes, 'minute')} ');
        }
        if (seconds > 0 &&
            settings.format == TimerFormat.descriptiveWithSeconds) {
          buffer.write(
              '${formatAsNumber(seconds)} ${fixGrammar(seconds, 'second')}');
        }
        break;
    }
    return buffer.toString().trim();
  }

  String formatAsNumber(int val) {
    final String value = val.toString();
    if (value.length <= 3) return value;
    final String lastThreeDigits = value.characters.takeLast(3).toString();
    final List<String> slices = value.characters
        .skipLast(3)
        .toString()
        .reversed
        .characters
        .slices(2)
        .map((e) => e.reversed.join())
        .toList()
        .reversed
        .toList();
    slices.add(lastThreeDigits);
    return slices.join(',');
  }

  String fixGrammar(int number, String word, {bool useArticleForOne = false}) {
    return Intl.plural(
      number,
      one: '${useArticleForOne ? 'a' : '1'} $word',
      other: '${word}s',
    );
  }

  double calculateMaxWidth(BuildContext context, TimerWidgetSettings settings) {
    final painter = TextPainter(
      text: TextSpan(
        text: '00:00:00',
        style: TextStyle(
          color: Colors.white,
          fontSize: settings.fontSize,
          fontFamily: settings.fontFamily,
          letterSpacing: 2,
          height: 1.4,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
      maxLines: 1,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      textDirection: TextDirection.ltr,
      // textAlign: settings.alignment.textAlign,
    );
    painter.layout();
    return painter.width;
  }
}
