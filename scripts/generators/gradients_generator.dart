import 'dart:convert';
import 'dart:io';
import 'package:dart_style/dart_style.dart';
import 'package:characters/characters.dart';

/// Run command: dart color_generator.dart <input.json> <output.dart>
/// Full command to run from project root:
///
/// dart scripts/generators/gradients_generator.dart scripts/generators/colors.json lib/resources/color_gradients.dart
///
/// Default output file name is flat_colors.dart
/// Default input file name is colors.json
void main(List<String> args) {
  // Read input file
  final String jsonFilePath = args.isNotEmpty ? args[0] : 'colors.json';
  final String colorsJsonString = File(jsonFilePath).readAsStringSync();

  // parse json
  final Map<String, dynamic> decodedJson = json.decode(colorsJsonString);
  final colorsJsonList =
      List<Map<String, dynamic>>.from(decodedJson['gradient']);

  // Generate
  final StringBuffer stringBuffer = StringBuffer();

  stringBuffer.writeln("import 'package:flutter/painting.dart';");
  stringBuffer.writeln("import '../model/color_gradient.dart';");
  stringBuffer.writeln('class ColorGradients {');
  stringBuffer.writeln('  const ColorGradients._();\n');

  final Map<String, String> values = {};

  for (final item in colorsJsonList) {
    final String name = item['name'].toString();
    final String variableName = parseVariableName(name);
    final String foregroundColor = parseColor(item['foreground'].toString());
    final List<List<String>> result =
        parseGradientColors(item['background'].toString());
    final List<String> colors = result[0];
    final List<String> stops = result[1];
    assert(colors.length == 2,
        'Gradient must have 2 colors ${item['background']}');

    stringBuffer.writeln(
        'static const ColorGradient $variableName = ColorGradient(name: \'$name\', colors: [Color(0XFF${colors[0]}), Color(0XFF${colors[1]})], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [${stops.join(', ')}], foreground: Color(0xFF$foregroundColor),);');

    values[name] = variableName;
  }

  // stringBuffer.writeln(
  //     '\n  static const List<ColorGradient> values = [${values.values.join(', ')}];');

  stringBuffer
      .writeln('\n  static const Map<String, ColorGradient> gradients = {');
  for (final entry in values.entries) {
    stringBuffer.writeln("    '${entry.key}': ${entry.value},");
  }

  stringBuffer.writeln('};');

  stringBuffer.writeln('}');

  // Format
  final String output = DartFormatter().format(stringBuffer.toString());

  // print to console
  stdout.writeln(output);

  // Write to output file
  final String outputFilePath =
      args.length > 1 ? args[1] : 'color_gradients.dart';
  File(outputFilePath).writeAsStringSync(output);
}

String parseVariableName(String name) {
  final List<String> words = name.split(' ');
  if (words.length == 1) {
    return name.toLowerCase();
  }
  for (int i = 1; i < words.length; i++) {
    words[i] = words[i].characters.first.toUpperCase() +
        words[i].substring(1).toLowerCase();
  }

  // Handle names starting with digits because dart doesn't support it. So
  // remove it and add it as suffix.
  final digitsRegex = RegExp(r'^[0-9]+');
  if (words.first.startsWith(digitsRegex)) {
    final prefix = digitsRegex.stringMatch(words.first)!;
    if (prefix == words.first) {
      // a complete word with only numbers
      words.removeAt(0);
    } else {
      words.first = words.first.replaceFirst(digitsRegex, '');
    }
    words.add(prefix);
  }
  words[0] = words.first.toLowerCase();
  return words.join();
}

String parseColor(String color) {
  String hex = color;
  if (color.startsWith('#')) {
    hex = color.substring(1);
  }
  if (hex.length == 3) {
    final tokens = hex.split('');
    hex = tokens.map((e) => '$e$e').join();
  }
  hex = hex.toUpperCase();
  return hex;
}

List<List<String>> parseGradientColors(String gradient) {
  final RegExp gradientRegex = RegExp(
      r'^linear-gradient\(to\sbottom,\s?#(?<color1>[A-Fa-f0-9]+)\s(?<stop1>[0-9]{0,3})?%?,\s?#(?<color2>[A-Fa-f0-9]+)\s(?<stop2>[0-9]{0,3})?%?\)$');
  final RegExpMatch? match = gradientRegex.firstMatch(gradient);
  assert(match != null, 'Invalid gradient format: $gradient');
  final List<String> colors = [
    parseColor(match!.namedGroup('color1').toString()),
    parseColor(match.namedGroup('color2').toString()),
  ];
  final List<String> stops = [
    (double.parse(match.namedGroup('stop1') ?? '0') / 100).toStringAsFixed(1),
    (double.parse(match.namedGroup('stop2') ?? '100') / 100).toStringAsFixed(1),
  ];
  return [colors, stops];
}
