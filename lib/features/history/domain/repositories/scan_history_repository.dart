import '../entities/scan_history.dart';

abstract class ScanHistoryRepository {
  Future<void> saveScan(ScanHistory scan);
  Future<List<ScanHistory>> getScans();
  Future<void> deleteScan(dynamic key);
  Future<void> clearHistory();
}
  