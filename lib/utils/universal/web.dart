import 'dart:typed_data';
import 'package:web/web.dart';

/// Web implementation for downloading image.
Future<void> downloadImage(Uint8List bytes, String path) async {
  HTMLAnchorElement()
    ..href = UriData.fromBytes(
      bytes,
      mimeType: 'image/jpeg',
    ).toString()
    ..setAttribute('download', path)
    ..click()
    ..remove();
}
