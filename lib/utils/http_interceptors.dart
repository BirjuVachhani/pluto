import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:screwdriver/screwdriver.dart';
import 'package:universal_io/io.dart';

class LoggerInterceptor extends InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) async {
    log('-' * 80);
    log('REQUEST: $request');
    log('-' * 80);
    _printHeaders(request.headers);
    log('-' * 80);
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    log('-' * 80);
    log('RESPONSE: ${response.statusCode} ${response.request}');
    log('-' * 80);
    _printHeaders(response.headers);
    if (response case Response(:final body)) {
      log('BODY:');
      if (response.headers[HttpHeaders.contentTypeHeader]?.contains('application/json') == true) {
        final json = tryJsonDecode(body);
        if (json != null) {
          log(const JsonEncoder.withIndent('  ').convert(json));
        } else {
          log(body);
        }
      } else {
        log(body);
      }
    }
    log('-' * 80);
    return response;
  }

  void _printHeaders(Map<String, String> headers) {
    log('HEADERS:');
    final maxKeyLength = headers.keys.map((e) => e.length).max;
    headers.entries
        .sorted((a, b) => a.key.compareTo(b.key))
        .forEach((entry) => log('${entry.key.padRight(maxKeyLength)} : ${entry.value}'));
  }
}

class ApiKeyInterceptor implements InterceptorContract {
  final String apiKey;

  const ApiKeyInterceptor({required this.apiKey});

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    request.headers['X-API-Key'] = apiKey;
    return request;
  }

  @override
  FutureOr<BaseResponse> interceptResponse({required BaseResponse response}) => response;

  @override
  FutureOr<bool> shouldInterceptRequest() => true;

  @override
  FutureOr<bool> shouldInterceptResponse() => false;
}
