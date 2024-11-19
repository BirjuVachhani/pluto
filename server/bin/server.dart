import 'dart:convert';
import 'dart:io';

import 'package:server/unsplash.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:unsplash_client/unsplash_client.dart' show Photo;

final String unsplashApiKey = Platform.environment['UNSPLASH_ACCESS_KEY'] ??
    String.fromEnvironment('UNSPLASH_ACCESS_KEY');

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler)
  ..post('/unsplash/randomImage', _unsplashRandomImageHandler);

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
      return Response.internalServerError(
          body: 'Could not get a photo from Unsplash.');
    }
    return Response.ok(jsonEncode(photo.toJson()),
        headers: {'Content-Type': 'application/json'});
  } catch (error, stacktrace) {
    return Response.internalServerError(body: 'Error: $error\n$stacktrace\n');
  }
}

void main(List<String> args) async {
  if (env['UNSPLASH_ACCESS_KEY'] == null) {
    print('UNSPLASH_ACCESS_KEY is missing.');
    exit(1);
  }

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(enableCors())
      .addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8000');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}

Middleware enableCors() {
  return (Handler handler) {
    return (Request request) async {
      // Handle preflight request (OPTIONS)
      if (request.method == 'OPTIONS') {
        return Response.ok(
          '',
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers':
                'Origin, Content-Type, Authorization',
          },
        );
      }

      // Forward request and add CORS headers
      final response = await handler(request);
      return response.change(
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
        },
      );
    };
  };
}
