import '../entities/scan_history.dart';
import '../repositories/scan_history_repository.dart';

class GetScansUseCase {
  final ScanHistoryRepository _repository;

  GetScansUseCase(this._repository);

  Future<List<ScanHistory>> call() async {
    return _repository.getScans();
  }
}
