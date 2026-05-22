import '../../data/models/disease_model.dart';
import '../repositories/disease_repository.dart';

class GetDiseasesUseCase {
  final DiseaseRepository _repository;

  const GetDiseasesUseCase(this._repository);

  Future<DiseaseListResponse> call({int page = 1}) =>
      _repository.getDiseases(page: page);
}
