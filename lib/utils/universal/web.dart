// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';

/// Web implementation for downloading image.
Future<void> downloadImage(Uint8List bytes, String path) async {
  final blob = Blob([bytes]);
  final url = Url.createObjectUrlFromBlob(blob);
  AnchorElement(href: url)
    ..setAttribute('download', path)
    ..click();
  Url.revokeObjectUrl(url);
}
