import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'gemini_api_constants.dart';

/// Singleton Dio instance pre-configured for the Gemini API.
/// Includes LogInterceptor for debugging requests and responses.
class GeminiDioClient {
  GeminiDioClient._();

  static Dio? _instance;

  static Dio get instance {
    _instance ??= Dio(
      BaseOptions(
        baseUrl: GeminiApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    )..interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: false,
          responseHeader: false,
          error: true,
          logPrint: (obj) => debugPrint('[Gemini] $obj'),
        ),
      );
    return _instance!;
  }
}
