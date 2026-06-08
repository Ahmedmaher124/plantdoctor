import '../repositories/scan_history_repository.dart';

class DeleteScanUseCase {
  final ScanHistoryRepository _repository;

  DeleteScanUseCase(this._repository);

  Future<void> call(dynamic key) async {
    return _repository.deleteScan(key);
  }
}
