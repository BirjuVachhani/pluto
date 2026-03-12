import 'dart:convert';
import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:screwdriver/screwdriver.dart';

class LoggerInterceptor extends InterceptorContract {
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
}
