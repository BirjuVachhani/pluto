import 'dart:convert';
import 'dart:io';

import 'package:pexels/pexels.dart' as pexels;
import 'package:server/pexels.dart' as pexels_service;
import 'package:server/unsplash.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:unsplash_client/unsplash_client.dart' show Photo;

final String unsplashApiKey =
    Platform.environment['UNSPLASH_ACCESS_KEY'] ?? String.fromEnvironment('UNSPLASH_ACCESS_KEY');

final String? apiKey = env['PLUTO_API_KEY'];

final bool enforceApiKey = bool.tryParse(Platform.environment['ENFORCE_API_KEY'] ?? 'false') == true;

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler)
  ..post('/unsplash/randomImage', _unsplashRandomImageHandler)
  ..post('/pexels/randomImage', _pexelsRandomImageHandler);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

Future<Response> _unsplashRandomImageHandler(Request request) async {
  try {
    final String payload = await request.readAsString();
    final Map<String, dynamic> sourceJson = jsonDecode(payload);
    final UnsplashSource source = UnsplashSource.fromJson(sourceJson['source']);
    final Photo? photo = await randomUnsplashImage(source: source);
    if (photo == null) {
      return Response.internalServerError(body: 'Could not get a photo from Unsplash.');
    }
    return Response.ok(jsonEncode(photo.toJson()), headers: {'Content-Type': 'application/json'});
  } catch (error, stacktrace) {
    return Response.internalServerError(body: 'Error: $error\n$stacktrace\n');
  }
}

Future<Response> _pexelsRandomImageHandler(Request request) async {
  try {
    final String payload = await request.readAsString();
    final Map<String, dynamic> sourceJson = jsonDecode(payload);
    final PexelsSource source = PexelsSource.fromJson(sourceJson['source']);
    final pexels.Photo? photo = await pexels_service.randomPexelsImage(source: source);
    if (photo == null) {
      return Response.internalServerError(body: 'Could not get a photo from Pexels.');
    }
    return Response.ok(jsonEncode(photo.toJson()), headers: {'Content-Type': 'application/json'});
  } catch (error, stacktrace) {
    return Response.internalServerError(body: 'Error: $error\n$stacktrace\n');
  }
}

void main(List<String> args) async {
  if (env['UNSPLASH_ACCESS_KEY'] == null) {
    print('UNSPLASH_ACCESS_KEY is missing.');
    exit(1);
  }

  if (enforceApiKey && env['PLUTO_API_KEY'] == null) {
    print('PLUTO_API_KEY is missing but ENFORCE_API_KEY is true.');
    exit(1);
  }

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  if (apiKey == null || apiKey!.trim().isEmpty) {
    throw StateError('PLUTO_API_KEY is missing or empty. Please set the PLUTO_API_KEY environment variable.');
  }

  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(enableCors())
      .addMiddleware(requireApiKey(apiKey!, enforce: enforceApiKey))
      .addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8000');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}

Middleware requireApiKey(String apiKey, {required bool enforce}) {
  return (Handler handler) {
    return (Request request) async {
      // Skip validation for preflight and health check.
      if (request.method == 'OPTIONS' || request.requestedUri.path == '/') {
        return handler(request);
      }
      final key = request.headers['X-API-Key'] ?? request.headers['x-api-key'];
      if (key != apiKey) {
        if (enforce) {
          return Response.forbidden('Invalid or missing API key.');
        }
        print('WARNING: Request without valid API key: ${request.requestedUri.path}');
      }
      return handler(request);
    };
  };
}

Middleware enableCors() {
  return (Handler handler) {
    return (Request request) async {
      final origin = request.headers['origin'] ?? '*';
      final isAllowed = origin.startsWith('chrome-extension://') || origin == 'http://localhost:5500';
      final corsHeaders = {
        if (isAllowed) 'Access-Control-Allow-Origin': origin,
        'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, X-API-Key',
        'Vary': 'Origin',
      };

      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: corsHeaders);
      }

      final response = await handler(request);
      return response.change(headers: corsHeaders);
    };
  };
}
