import '../../domain/entities/scan_history.dart';
import '../../domain/repositories/scan_history_repository.dart';
import '../datasource/scan_history_local_datasource.dart';
import '../models/scan_history_model.dart';

class ScanHistoryRepositoryImpl implements ScanHistoryRepository {
  final ScanHistoryLocalDataSource _localDataSource;

  ScanHistoryRepositoryImpl(this._localDataSource);

  @override
  Future<void> saveScan(ScanHistory scan) async {
    final model = ScanHistoryModel.fromEntity(scan);
    await _localDataSource.saveScan(model);
  }

  @override
  Future<List<ScanHistory>> getScans() async {
    final models = await _localDataSource.getScans();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> deleteScan(dynamic key) async {
    await _localDataSource.deleteScan(key);
  }

  @override
  Future<void> clearHistory() async {
    await _localDataSource.clearHistory();
  }
}
