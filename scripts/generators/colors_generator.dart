import 'dart:convert';
import 'dart:io';
import 'package:dart_style/dart_style.dart';
import 'package:characters/characters.dart';

/// Run command: dart color_generator.dart [input.json] [output.dart]
/// Full command to run from project root:
///
/// dart scripts/generators/colors_generator.dart scripts/generators/colors.json lib/resources/flat_colors.dart
///
/// Default output file name is flat_colors.dart
/// Default input file name is colors.json
void main(List<String> args) {
  // Read input file
  final String jsonFilePath = args.isNotEmpty ? args[0] : 'colors.json';
  final String colorsJsonString = File(jsonFilePath).readAsStringSync();

  // parse json
  final Map<String, dynamic> decodedJson = json.decode(colorsJsonString);
  final colorsJsonList = List<Map<String, dynamic>>.from(decodedJson['flat']);

  // Generate
  final StringBuffer stringBuffer = StringBuffer();

  stringBuffer.writeln("import 'package:flutter/painting.dart';");
  stringBuffer.writeln("import '../model/flat_color.dart';");
  stringBuffer.writeln('class FlatColors {');
  stringBuffer.writeln('  const FlatColors._();\n');

  final Map<String, String> values = {};

  for (final item in colorsJsonList) {
    final String name = item['name'].toString();
    final String variableName = parseVariableName(name);
    final String backgroundColor = parseColor(item['background'][0].toString());
    final String foregroundColor = parseColor(item['foreground'].toString());
    stringBuffer.writeln(
        'static const FlatColor $variableName = FlatColor(name: \'$name\', background: Color(0XFF$backgroundColor), foreground: Color(0XFF$foregroundColor),);');

    values[name] = variableName;
  }

  // stringBuffer.writeln(
  //     '\n  static const List<FlatColor> values = [${values.values.join(', ')}];');

  stringBuffer.writeln('\n  static const Map<String, FlatColor> colors = {');
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
  final String outputFilePath = args.length > 1 ? args[1] : 'flat_colors.dart';
  File(outputFilePath).writeAsStringSync(output);
}

String parseVariableName(String name) {
  final words = name.split(' ');
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
