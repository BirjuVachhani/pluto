import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';
import 'package:unsplash_client/unsplash_client.dart';

import 'backend_service.dart';

class RestBackendService extends BackendService {
  String baseUrl = '';

  @override
  Future<void> init({bool local = false}) async {
    if (local) {
      log('Initializing backend with local server');
      baseUrl = 'http://localhost:8000';
    } else {
      log('Initializing backend with production server');
      baseUrl = 'https://pluto.globe.dev';
    }
  }

  @override
  Future<Photo?> randomUnsplashImage({
    required UnsplashSource source,
    required UnsplashPhotoOrientation orientation,
  }) async {
    final result = await http.post(
      Uri.parse('$baseUrl/unsplash/randomImage'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'source': source.toJson(),
        'orientation': orientation.name,
      }),
    );
    if (result.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(result.body);
      return Photo.fromJson(json);
    }
    print(result.body);
    throw HttpException(result.body);
  }
}
