import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln(
        'Usage: animated_logo_resizer.dart <input_file> <output_file> <size>');
    exit(0);
  }
  if (args.length != 3) {
    stderr.writeln('Must provide required args:\n'
        'Usage: animated_logo_resizer.dart <input_file> <output_file> <size>');
    exit(1);
  }

  const double multiplier = 0.64453;

  final int size = int.parse(args[2]);
  int contentSize = (size * multiplier).round();

  // This ensures the margin is a whole number such that the difference
  // between the content size and the total size is an even number.
  if (size.isOdd && contentSize.isEven) {
    contentSize++;
  } else if (size.isEven && contentSize.isOdd) {
    contentSize++;
  }

  final int margin = (size - contentSize) ~/ 2;

  final inputFile = File(args[0]);
  final outputFile = File(args[1]);

  final content = inputFile.readAsStringSync();

  final String updatedContent = content
      .replaceAll('[[SIZE]]', size.toString())
      .replaceAll('[[CONTENT_SIZE]]', contentSize.toString())
      .replaceAll('[[MARGIN]]', margin.toString());

  outputFile.writeAsStringSync(updatedContent);

  stdout.writeln('Generated Successfully!');
}
