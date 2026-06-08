import 'package:dio/dio.dart';
import '../models/disease_model.dart';

abstract class DiseaseRemoteDataSource {
  Future<DiseaseListResponse> getDiseases({int page = 1});
}

class DiseaseRemoteDataSourceImpl implements DiseaseRemoteDataSource {
  final Dio _dio;
  final String _apiKey;

  static const String _baseUrl = 'https://perenual.com/api/';
  static const String _endpoint = 'pest-disease-list';

  const DiseaseRemoteDataSourceImpl({
    required Dio dio,
    required String apiKey,
  })  : _dio = dio,
        _apiKey = apiKey;

  @override
  Future<DiseaseListResponse> getDiseases({int page = 1}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_baseUrl$_endpoint',
        queryParameters: {
          'key': _apiKey,
          'page': page,
        },
      );

      final data = response.data;
      if (data == null) throw Exception('Empty response from server');

      return DiseaseListResponse.fromJson(data);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message = e.response?.data?['message'] ?? e.message;

      if (statusCode == 401 || statusCode == 403) {
        throw Exception('Invalid API key. Check your Perenual API key.');
      }
      if (statusCode == 429) {
        throw Exception('API rate limit exceeded. Please wait and retry.');
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Connection timed out. Check your internet connection.');
      }
      throw Exception('Network error: $message');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Unexpected error: $e');
    }
  }
}
