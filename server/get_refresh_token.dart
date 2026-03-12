import 'dart:convert';
import 'dart:io';

import 'package:server/base/env.dart';

const scope = 'https://www.googleapis.com/auth/chromewebstore';
const redirectUri = 'http://localhost:8844';

void main() async {
  final clientId = env['GOOGLE_CLIENT_ID'];
  if (clientId == null || clientId.isEmpty) {
    print('ERROR: GOOGLE_CLIENT_ID environment variable is not set.');
    exit(1);
  }

  final clientSecret = env['GOOGLE_CLIENT_SECRET'];
  if (clientSecret == null || clientSecret.isEmpty) {
    print('ERROR: GOOGLE_CLIENT_SECRET environment variable is not set.');
    exit(1);
  }

  final authUrl = Uri.parse(
    'https://accounts.google.com/o/oauth2/auth'
    '?response_type=code'
    '&scope=${Uri.encodeComponent(scope)}'
    '&client_id=$clientId'
    '&redirect_uri=${Uri.encodeComponent(redirectUri)}',
  );

  // Start a local server to capture the redirect.
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8844);

  print('Authorization URL:\n$authUrl\n');

  print('Opening browser for authorization...');
  await Process.run('open', [authUrl.toString()]);

  print('Waiting for authorization...');
  String? code;
  await for (final request in server) {
    code = request.uri.queryParameters['code'];
    request.response
      ..statusCode = 200
      ..headers.contentType = ContentType.html
      ..write('<h2>Authorization complete. You can close this tab.</h2>');
    await request.response.close();
    break;
  }
  await server.close();

  if (code == null) {
    print('ERROR: No authorization code received.');
    exit(1);
  }

  print('Got authorization code. Exchanging for refresh token...\n');

  stdout.write('Enter your client secret: ');

  final client = HttpClient();
  final tokenRequest = await client.postUrl(
    Uri.parse('https://oauth2.googleapis.com/token'),
  );
  tokenRequest.headers.contentType = ContentType('application', 'x-www-form-urlencoded');
  final body = Uri(
    queryParameters: {
      'client_id': clientId,
      'client_secret': clientSecret,
      'code': code,
      'grant_type': 'authorization_code',
      'redirect_uri': redirectUri,
    },
  ).query;
  tokenRequest.write(body);
  final tokenResponse = await tokenRequest.close();
  final responseBody = await tokenResponse.transform(utf8.decoder).join();
  client.close();

  final json = jsonDecode(responseBody) as Map<String, dynamic>;

  if (json.containsKey('refresh_token')) {
    print('\nRefresh Token:\n${json['refresh_token']}\n');
    print('Update the CHROME_REFRESH_TOKEN GitHub secret with this value.');
  } else {
    print('\nERROR: No refresh token in response.');
    print('Response: $responseBody');
  }
}
