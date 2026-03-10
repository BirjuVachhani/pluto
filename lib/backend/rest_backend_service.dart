import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared/shared.dart';
import 'package:unsplash_client/unsplash_client.dart';

import '../utils/http_interceptors.dart';
import 'backend_service.dart';

const String _apiKey = String.fromEnvironment('PLUTO_API_KEY');
const String cloudRunUrl = 'https://pluto-510516922464.asia-south1.run.app';

class RestBackendService extends BackendService {
  String baseUrl = '';

  final http.Client client = InterceptedClient.build(
    interceptors: [
      ApiKeyInterceptor(apiKey: _apiKey),
      if (kDebugMode) LoggerInterceptor(),
    ],
  );

  @override
  Future<void> init({bool local = false}) async {
    if (local) {
      log('Initializing backend with local server');
      baseUrl = 'http://localhost:8000';
    } else {
      log('Initializing backend with production server');
      baseUrl = cloudRunUrl;
    }
  }

  @override
  Future<Photo?> randomUnsplashImage({
    required UnsplashSource source,
    required UnsplashPhotoOrientation orientation,
  }) async {
    final result = await client.post(
      Uri.parse('$baseUrl/unsplash/randomImage'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'source': source.toJson(), 'orientation': orientation.name}),
    );
    if (result.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(result.body);
      return Photo.fromJson(json);
    }
    log(result.body);
    throw HttpException(result.body);
  }
}
