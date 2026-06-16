import 'package:hive/hive.dart';
import '../models/scan_history_model.dart';

abstract class ScanHistoryLocalDataSource {
  Future<void> saveScan(ScanHistoryModel scan);
  Future<List<ScanHistoryModel>> getScans();
  Future<void> deleteScan(dynamic key);
  Future<void> clearHistory();
}

class ScanHistoryLocalDataSourceImpl implements ScanHistoryLocalDataSource {
  final Box<ScanHistoryModel> _box;

  ScanHistoryLocalDataSourceImpl(this._box);

  @override
  Future<void> saveScan(ScanHistoryModel scan) async {
    await _box.add(scan);
  }

  @override
  Future<List<ScanHistoryModel>> getScans() async {
    return _box.values.toList();
  }

  @override
  Future<void> deleteScan(dynamic key) async {
    await _box.delete(key);
  }

  @override
  Future<void> clearHistory() async {
    await _box.clear();
  }
}
