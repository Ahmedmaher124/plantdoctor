import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/disease_model.dart';
import '../../domain/usecases/get_diseases_usecase.dart';
import 'disease_state.dart';

class DiseaseCubit extends Cubit<DiseaseState> {
  final GetDiseasesUseCase _getDiseasesUseCase;

  int _currentPage = 1;
  bool _isFetching = false;

  DiseaseCubit({required GetDiseasesUseCase getDiseasesUseCase})
      : _getDiseasesUseCase = getDiseasesUseCase,
        super(const DiseaseInitial());

  /// Load the first page of diseases.
  Future<void> loadDiseases() async {
    if (_isFetching) return;
    _isFetching = true;
    _currentPage = 1;
    emit(const DiseaseLoading());

    try {
      final result = await _getDiseasesUseCase(page: 1);

      if (result.diseases.isEmpty) {
        emit(const DiseaseEmpty());
      } else {
        emit(DiseaseLoaded(
          diseases: result.diseases,
          hasMore: result.hasMorePages,
        ));
      }
    } catch (e) {
      emit(DiseaseError(e.toString().replaceFirst('Exception: ', '')));
    } finally {
      _isFetching = false;
    }
  }

  /// Load the next page and append to existing list.
  Future<void> loadMoreDiseases() async {
    final current = state;
    if (current is! DiseaseLoaded || !current.hasMore || _isFetching) return;

    _isFetching = true;
    _currentPage++;

    emit(current.copyWith(isLoadingMore: true));

    try {
      final result = await _getDiseasesUseCase(page: _currentPage);

      final merged = List<DiseaseModel>.from(current.diseases)
        ..addAll(result.diseases);

      emit(DiseaseLoaded(
        diseases: merged,
        hasMore: result.hasMorePages,
      ));
    } catch (e) {
      // Rollback page counter and restore loaded state without loading indicator
      _currentPage--;
      emit(current.copyWith(isLoadingMore: false));
    } finally {
      _isFetching = false;
    }
  }

  /// Refresh — reload from page 1.
  Future<void> refresh() => loadDiseases();
}
