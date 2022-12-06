import 'dart:io';
import 'dart:typed_data';

Future<void> downloadImage(Uint8List bytes, String path) =>
    File(path).writeAsBytes(bytes);
