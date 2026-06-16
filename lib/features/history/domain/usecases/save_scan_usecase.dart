import '../entities/scan_history.dart';
import '../repositories/scan_history_repository.dart';

class SaveScanUseCase {
  final ScanHistoryRepository _repository;

  SaveScanUseCase(this._repository);

  Future<void> call(ScanHistory scan) async {
    return _repository.saveScan(scan);
  }
}
