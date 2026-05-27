import 'dart:io';

import '../../../../core/network/api_client.dart';
import '../models/disease_prediction_response.dart';

class DiseasePredictionRepository {
  static const String _endpoint = 'http://api.ecocity.info/api/disease/predict';

  final ApiClient _apiClient;

  const DiseasePredictionRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<DiseasePredictionResponse> predictDisease(File imageFile) async {
    final json = await _apiClient.postMultipart(
      url: _endpoint,
      fileField: 'image',
      file: imageFile,
    );

    return DiseasePredictionResponse.fromJson(json);
  }
}
