import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

/// Updates the version in web/manifest.json to match with the version in pubspec.yaml.
void main(List<String> args) {
  final File manifestFile = File('web/manifest.json');
  final File pubspecFile = File('pubspec.yaml');
  final String version =
      loadYaml(pubspecFile.readAsStringSync())['version'].toString();

  final Map<String, dynamic> manifest =
      jsonDecode(manifestFile.readAsStringSync());

  manifest['version'] = version.split('+').first;

  manifestFile
      .writeAsStringSync(const JsonEncoder.withIndent('  ').convert(manifest));
  stdout.writeln('Updated manifest version to $version');

  // final File versionFile = File('lib/src/version.dart');
  // versionFile.createSync(recursive: true);

  // versionFile.writeAsStringSync('const String packageVersion = \'$version\';');
  stdout.writeln('Updated version.dart to $version');
  exit(0);
}
