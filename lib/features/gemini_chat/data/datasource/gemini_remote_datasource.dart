import 'package:dio/dio.dart';
import '../../../../core/network/gemini_api_constants.dart';
import '../../domain/entities/chat_message.dart';
import '../models/gemini_request_model.dart';
import '../models/gemini_response_model.dart';

/// Remote data source: calls the Gemini generateContent API via Dio.
abstract class GeminiRemoteDataSource {
  Future<String> sendMessage(List<ChatMessage> messages);
}

class GeminiRemoteDataSourceImpl implements GeminiRemoteDataSource {
  final Dio _dio;
  final String _apiKey;

  const GeminiRemoteDataSourceImpl({
    required Dio dio,
    required String apiKey,
  })  : _dio = dio,
        _apiKey = apiKey;

  @override
  Future<String> sendMessage(List<ChatMessage> messages) async {
    final endpoint = GeminiApiConstants.generateContentEndpoint(_apiKey);
    final body = GeminiRequestModel.buildBody(
      messages: messages,
      systemPrompt: GeminiApiConstants.systemPrompt,
    );

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        endpoint,
        data: body,
      );

      final data = response.data;
      if (data == null) throw Exception('Empty response from Gemini API');

      if (GeminiResponseModel.isBlocked(data)) {
        throw Exception(
            'Response was blocked by safety filters. Please rephrase your question.');
      }

      return GeminiResponseModel.parseReplyText(data);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message = e.response?.data?['error']?['message'] ?? e.message;

      if (statusCode == 400) throw Exception('Bad request: $message');
      if (statusCode == 401 || statusCode == 403) {
        throw Exception('Invalid API key. Please check your configuration.');
      }
      if (statusCode == 429) {
        throw Exception('Rate limit exceeded. Please wait and try again.');
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
            'Request timed out. Check your internet connection and try again.');
      }
      throw Exception('Network error: $message');
    } on FormatException catch (e) {
      throw Exception('Failed to parse response: ${e.message}');
    }
  }
}
