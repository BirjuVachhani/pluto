import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

Future<void> downloadImage(Uint8List bytes, String path) =>
    File(path).writeAsBytes(bytes);

Future<String?> getRedirectionUrl(String url) async {
  final client = http.Client();
  var uri = Uri.parse(url);
  var request = http.Request('get', uri);
  request.followRedirects = false;
  var response = await client.send(request);
  return response.headers['location'];
}
