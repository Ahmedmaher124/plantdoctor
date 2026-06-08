import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/delete_scan_usecase.dart';
import '../../domain/usecases/clear_history_usecase.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final DeleteScanUseCase _deleteScanUseCase;
  final ClearHistoryUseCase _clearHistoryUseCase;

  HistoryCubit({
    required DeleteScanUseCase deleteScanUseCase,
    required ClearHistoryUseCase clearHistoryUseCase,
  })  : _deleteScanUseCase = deleteScanUseCase,
        _clearHistoryUseCase = clearHistoryUseCase,
        super(HistoryInitial());

  Future<void> deleteScan(dynamic key) async {
    await _deleteScanUseCase(key);
  }

  Future<void> clearAllHistory() async {
    await _clearHistoryUseCase();
  }
}
