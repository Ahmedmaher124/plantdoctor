import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../data/models/disease_prediction_response.dart';

enum DiseasePredictionErrorType {
  noInternet,
  timeout,
  server,
  invalidResponse,
  cameraPermissionDenied,
  galleryPermissionDenied,
  cameraCancelled,
  unknown,
}

abstract class DiseasePredictionState extends Equatable {
  final File? imageFile;

  const DiseasePredictionState({this.imageFile});

  @override
  List<Object?> get props => [imageFile?.path];
}

class DiseasePredictionInitial extends DiseasePredictionState {
  const DiseasePredictionInitial();
}

class DiseasePredictionLoading extends DiseasePredictionState {
  const DiseasePredictionLoading({required super.imageFile});
}

class DiseasePredictionSuccess extends DiseasePredictionState {
  final DiseasePredictionResponse response;

  const DiseasePredictionSuccess({required super.imageFile, required this.response});

  @override
  List<Object?> get props => [imageFile?.path, response];
}

class DiseasePredictionFailure extends DiseasePredictionState {
  final DiseasePredictionErrorType errorType;
  final int? statusCode;

  const DiseasePredictionFailure({
    required super.imageFile,
    required this.errorType,
    this.statusCode,
  });

  @override
  List<Object?> get props => [imageFile?.path, errorType, statusCode];
}
