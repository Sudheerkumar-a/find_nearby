import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Logs Places requests and responses in debug only. Keys are redacted.
final class DebugDioInterceptor extends Interceptor {
  const DebugDioInterceptor({this.label = 'Places'});

  final String label;

  /// Cap so huge FeatureCollections don't flood the console.
  static const _maxBody = 4000;
  static const _chunk = 800;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final query = options.queryParameters.isEmpty
        ? ''
        : '\nquery: ${_pretty(options.queryParameters)}';
    final body = options.data == null ? '' : '\nbody: ${_pretty(options.data)}';
    _log(
      '[$label] → ${options.method} ${_redact('${options.uri}')}$query$body',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _log(
      '[$label] ← ${response.statusCode} '
      '${_redact('${response.requestOptions.uri}')}\n'
      '${_pretty(response.data)}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log(
      '[$label] ✖ ${err.type.name} ${err.response?.statusCode ?? ''} '
      '${_redact('${err.requestOptions.uri}')}\n'
      '${err.message ?? ''}\n'
      '${_pretty(err.response?.data)}',
    );
    handler.next(err);
  }

  /// Android logcat / IDE consoles drop very long single lines — chunk them.
  void _log(String message) {
    if (message.length <= _chunk) {
      debugPrint(message);
      return;
    }
    for (var i = 0; i < message.length; i += _chunk) {
      final end = i + _chunk > message.length ? message.length : i + _chunk;
      debugPrint(message.substring(i, end));
    }
  }

  String _pretty(Object? data) {
    if (data == null) return '';
    try {
      final raw = data is String
          ? data
          : const JsonEncoder.withIndent('  ').convert(data);
      return _redact(raw);
    } catch (_) {
      return _redact('$data');
    }
  }

  String _redact(String raw) {
    final redacted = raw.replaceAll(
      RegExp(r'(?:apiKey=|key=)[^&\s"]+|AIza[0-9A-Za-z_\-]+'),
      '***',
    );
    if (redacted.length <= _maxBody) return redacted;
    return '${redacted.substring(0, _maxBody)}\n… truncated (${redacted.length} chars)';
  }
}
