import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:screwdriver/screwdriver.dart';

class LoggerInterceptor implements HttpInterceptor {
  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) async {
    print('-' * 80);
    print('REQUEST: $request');
    print('-' * 80);
    print('HEADERS:');
    print(request.headers.toString());
    print('-' * 80);
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    print('-' * 80);
    print('RESPONSE: ${response.statusCode} ${response.request}');
    print('-' * 80);
    print('HEADERS:');
    final maxKeyLength = response.headers.keys.map((e) => e.length).max;
    response.headers.entries
        .sorted((a, b) => a.key.compareTo(b.key))
        .forEach((entry) => print('${entry.key.padRight(maxKeyLength)} : ${entry.value}'));
    if (response case Response(:final body)) {
      print('BODY:');
      if (response.headers[HttpHeaders.contentTypeHeader]?.contains('application/json') == true) {
        final json = tryJsonDecode(body);
        if (json != null) {
          print(const JsonEncoder.withIndent('  ').convert(json));
        } else {
          print(body);
        }
      } else {
        print(body);
      }
    }
    print('-' * 80);
    return response;
  }

  @override
  FutureOr<bool> shouldInterceptRequest({required BaseRequest request}) => true;

  @override
  FutureOr<bool> shouldInterceptResponse({required BaseResponse response}) => true;
}

/// Repairs Unsplash API responses before `unsplash_client` deserializes them.
///
/// `unsplash_client` 3.0.0 declares several `UserLinks` URLs as non-nullable
/// (`self`, `html`, `photos`, `portfolio`) and casts them with `as String`. The
/// Unsplash API legitimately returns `null` for `portfolio` (and occasionally
/// the others) when a photographer has no portfolio set, which makes
/// `UserLinks.fromJson` throw `type 'Null' is not a subtype of type 'String'`
/// and fails the whole photo fetch.
///
/// We can't patch the package, so we backfill any missing/null link with the
/// photographer's profile (`html`) URL — a sensible, non-null stand-in — before
/// the buggy `fromJson` runs.
class UnsplashNullSafetyInterceptor implements HttpInterceptor {
  /// The `UserLinks` fields that the package incorrectly treats as required.
  static const _requiredUserLinks = ['self', 'html', 'photos', 'portfolio'];

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async => request;

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {
    // `unsplash_client` consumes responses via `Client.send`, so they arrive as
    // a (streamed) `StreamedResponse`. Anything else, or a non-Unsplash/non-JSON
    // response, is passed through untouched.
    final isUnsplash = response.request?.url.host.contains('unsplash.com') ?? false;
    final isJson = response.headers[HttpHeaders.contentTypeHeader]?.contains('application/json') ?? false;
    if (response is! StreamedResponse || !isUnsplash || !isJson) return response;

    final bytes = await response.stream.toBytes();
    final dynamic json = tryJsonDecode(utf8.decode(bytes));
    if (json == null) {
      // Decoding failed; hand the original bytes back so nothing is lost.
      return _rebuild(response, bytes);
    }

    _sanitize(json);
    return _rebuild(response, utf8.encode(jsonEncode(json)));
  }

  /// Walks a decoded `/photos/...` payload (a single photo or a list of them)
  /// and backfills any null `user.links` entries the package can't handle.
  void _sanitize(dynamic json) {
    if (json is List) {
      json.forEach(_sanitize);
      return;
    }
    if (json is! Map) return;

    final links = (json['user'] as Map?)?['links'];
    if (links is Map) {
      final fallback = links['html'] ?? links['self'] ?? 'https://unsplash.com';
      for (final key in _requiredUserLinks) {
        links[key] ??= fallback;
      }
    }
  }

  /// Wraps [bytes] back into a [StreamedResponse], preserving response metadata
  /// and correcting `content-length`.
  StreamedResponse _rebuild(StreamedResponse original, List<int> bytes) {
    return StreamedResponse(
      ByteStream.fromBytes(bytes),
      original.statusCode,
      contentLength: bytes.length,
      request: original.request,
      headers: {
        ...original.headers,
        HttpHeaders.contentLengthHeader: '${bytes.length}',
      },
      isRedirect: original.isRedirect,
      persistentConnection: original.persistentConnection,
      reasonPhrase: original.reasonPhrase,
    );
  }

  @override
  FutureOr<bool> shouldInterceptRequest({required BaseRequest request}) => true;

  @override
  FutureOr<bool> shouldInterceptResponse({required BaseResponse response}) => true;
}
