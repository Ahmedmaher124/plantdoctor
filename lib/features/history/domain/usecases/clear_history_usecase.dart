import '../repositories/scan_history_repository.dart';

class ClearHistoryUseCase {
  final ScanHistoryRepository _repository;

  ClearHistoryUseCase(this._repository);

  Future<void> call() async {
    return _repository.clearHistory();
  }
}
