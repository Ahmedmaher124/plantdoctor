import '../../data/models/disease_model.dart';

/// Abstract repository contract for disease data.
abstract class DiseaseRepository {
  Future<DiseaseListResponse> getDiseases({int page = 1});
}
