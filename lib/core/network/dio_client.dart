import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../errors/app_exception.dart';
import 'debug_dio_interceptor.dart';

Dio createPlacesDio({String? apiKey}) {
  final key = apiKey ?? AppConfig.googlePlacesApiKey;
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://places.googleapis.com',
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json', 'X-Goog-Api-Key': key},
    ),
  );
  if (kDebugMode) {
    dio.interceptors.add(const DebugDioInterceptor(label: 'Google'));
  }
  return dio;
}

Dio createGeoapifyDio({String? apiKey}) {
  final key = apiKey ?? AppConfig.geoapifyApiKey;
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.geoapify.com',
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 20),
      queryParameters: {'apiKey': key},
    ),
  );
  if (kDebugMode) {
    dio.interceptors.add(const DebugDioInterceptor(label: 'Geoapify'));
  }
  return dio;
}

AppException mapDioError(Object error) {
  if (error is DioException) {
    if (error.type == DioExceptionType.cancel) {
      return const UnexpectedException(message: 'Search was cancelled.');
    }
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return NetworkException(cause: error);
    }
    return ApiException.fromStatus(error.response?.statusCode, cause: error);
  }
  return UnexpectedException(cause: error);
}
