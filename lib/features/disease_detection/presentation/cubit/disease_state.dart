import 'package:equatable/equatable.dart';
import '../../data/models/disease_model.dart';

abstract class DiseaseState extends Equatable {
  const DiseaseState();
  @override
  List<Object?> get props => [];
}

class DiseaseInitial extends DiseaseState {
  const DiseaseInitial();
}

class DiseaseLoading extends DiseaseState {
  const DiseaseLoading();
}

/// Diseases loaded; [isLoadingMore] is true while fetching next page.
class DiseaseLoaded extends DiseaseState {
  final List<DiseaseModel> diseases;
  final bool hasMore;
  final bool isLoadingMore;

  const DiseaseLoaded({
    required this.diseases,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  DiseaseLoaded copyWith({
    List<DiseaseModel>? diseases,
    bool? hasMore,
    bool? isLoadingMore,
  }) =>
      DiseaseLoaded(
        diseases: diseases ?? this.diseases,
        hasMore: hasMore ?? this.hasMore,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );

  @override
  List<Object?> get props => [diseases, hasMore, isLoadingMore];
}

class DiseaseError extends DiseaseState {
  final String message;
  const DiseaseError(this.message);
  @override
  List<Object?> get props => [message];
}

class DiseaseEmpty extends DiseaseState {
  const DiseaseEmpty();
}
