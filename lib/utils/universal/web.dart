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

/// Setting followRedirects to false in http client doesn't work on flutter web
/// so this uses [HttpRequest] from dart:html to make a request and retrieve
/// the redirect url.
/// Issue: https://github.com/dart-lang/http/issues/432
Future<String?> getRedirectionUrl(String url) async {
  final htmlRequest = await HttpRequest.request(url, method: 'GET');
  return htmlRequest.responseUrl;
}
