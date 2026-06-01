import 'dart:io';

import 'package:dio/dio.dart';

import 'api_exceptions.dart';

class ApiClient {
  final Dio _dio;
  final Duration _timeout;

  ApiClient({
    required Dio dio,
    Duration timeout = const Duration(seconds: 20),
  })  : _dio = dio,
        _timeout = timeout;

  Future<Map<String, dynamic>> postMultipart({
    required String url,
    required String fileField,
    required File file,
  }) async {
    try {
      final formData = FormData.fromMap({
        fileField: await MultipartFile.fromFile(file.path),
      });

      final response = await _dio.post<Map<String, dynamic>>(
        url,
        data: formData,
        options: Options(
          headers: const {'Accept': 'application/json'},
          sendTimeout: _timeout,
          receiveTimeout: _timeout,
        ),
      );

      final data = response.data;
      if (data == null) {
        throw const InvalidResponseException('Empty response body');
      }

      return data;
    } on SocketException {
      throw const NetworkException();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutApiException();
      }

      final statusCode = e.response?.statusCode;
      if (statusCode != null) {
        throw ServerException(
          statusCode: statusCode,
          responseBody: e.response?.data?.toString() ?? '',
        );
      }

      throw ApiException(e.message ?? 'Request failed');
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
