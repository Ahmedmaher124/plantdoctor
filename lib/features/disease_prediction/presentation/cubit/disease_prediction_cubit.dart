import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantdoctor/features/disease_prediction/data/models/disease_prediction_response.dart';

import '../../../../core/network/api_exceptions.dart';
import '../../data/repositories/disease_prediction_repository.dart';
import 'disease_prediction_state.dart';

class DiseasePredictionCubit extends Cubit<DiseasePredictionState> {
  final DiseasePredictionRepository _repository;
  final ImagePicker _imagePicker;

  DiseasePredictionCubit({
    required DiseasePredictionRepository repository,
    ImagePicker? imagePicker,
  })  : _repository = repository,
        _imagePicker = imagePicker ?? ImagePicker(),
        super(const DiseasePredictionInitial());

  Future<void> captureAndPredict() async {
    await pickAndPredict(ImageSource.camera);
  }

  Future<void> pickFromGallery() async {
    await pickAndPredict(ImageSource.gallery);
  }

  Future<DiseasePredictionResponse?> pickAndPredict(ImageSource source) async {
    final imageFile = await pickImage(source);
    if (imageFile == null) {
      return null;
    }

    return predictWithImage(imageFile);
  }

  Future<File?> pickImage(ImageSource source) async {
    try {
      final captured = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (captured == null) {
        emit(const DiseasePredictionFailure(
          imageFile: null,
          errorType: DiseasePredictionErrorType.cameraCancelled,
        ));
        return null;
      }

      return File(captured.path);
    } on PlatformException {
      emit(DiseasePredictionFailure(
        imageFile: null,
        errorType: source == ImageSource.camera
            ? DiseasePredictionErrorType.cameraPermissionDenied
            : DiseasePredictionErrorType.galleryPermissionDenied,
      ));
      return null;
    }
  }

  Future<DiseasePredictionResponse?> predictWithImage(File imageFile) async {
    emit(DiseasePredictionLoading(imageFile: imageFile));

    try {
      final response = await _repository.predictDisease(imageFile);
      emit(DiseasePredictionSuccess(imageFile: imageFile, response: response));
      return response;
    } on NetworkException {
      emit(DiseasePredictionFailure(
        imageFile: imageFile,
        errorType: DiseasePredictionErrorType.noInternet,
      ));
    } on TimeoutApiException {
      emit(DiseasePredictionFailure(
        imageFile: imageFile,
        errorType: DiseasePredictionErrorType.timeout,
      ));
    } on ServerException catch (e) {
      emit(DiseasePredictionFailure(
        imageFile: imageFile,
        errorType: DiseasePredictionErrorType.server,
        statusCode: e.statusCode,
      ));
    } on InvalidResponseException {
      emit(DiseasePredictionFailure(
        imageFile: imageFile,
        errorType: DiseasePredictionErrorType.invalidResponse,
      ));
    } catch (_) {
      emit(DiseasePredictionFailure(
        imageFile: imageFile,
        errorType: DiseasePredictionErrorType.unknown,
      ));
    }

    return null;
  }
}
