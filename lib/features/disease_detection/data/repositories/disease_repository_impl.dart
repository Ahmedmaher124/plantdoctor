import '../../data/models/disease_model.dart';
import '../../domain/repositories/disease_repository.dart';
import '../datasource/disease_remote_datasource.dart';

class DiseaseRepositoryImpl implements DiseaseRepository {
  final DiseaseRemoteDataSource _dataSource;

  const DiseaseRepositoryImpl(this._dataSource);

  @override
  Future<DiseaseListResponse> getDiseases({int page = 1}) =>
      _dataSource.getDiseases(page: page);
}
