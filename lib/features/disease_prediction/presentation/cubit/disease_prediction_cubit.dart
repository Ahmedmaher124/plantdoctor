import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantdoctor/features/disease_prediction/data/models/disease_prediction_response.dart';

import '../../../../core/network/api_exceptions.dart';
import '../../data/repositories/disease_prediction_repository.dart';
import 'disease_prediction_state.dart';
import '../../../history/domain/usecases/save_scan_usecase.dart';
import '../../../history/domain/entities/scan_history.dart';

class DiseasePredictionCubit extends Cubit<DiseasePredictionState> {
  final DiseasePredictionRepository _repository;
  final ImagePicker _imagePicker;
  final SaveScanUseCase _saveScanUseCase;

  DiseasePredictionCubit({
    required DiseasePredictionRepository repository,
    required SaveScanUseCase saveScanUseCase,
    ImagePicker? imagePicker,
  })  : _repository = repository,
        _saveScanUseCase = saveScanUseCase,
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
      
      // Auto-save scan history
      await _saveScanToHistory(imageFile.path, response);
      
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

  Future<void> _saveScanToHistory(String imagePath, DiseasePredictionResponse response) async {
    try {
      final label = response.label ?? 'Plant___healthy';
      
      String plantName = 'Unknown';
      String diseaseName = 'Unknown';
      bool isHealthy = false;

      if (label.contains('___')) {
        final parts = label.split('___');
        plantName = _formatName(parts[0]);
        diseaseName = _formatName(parts[1]);
      } else {
        final lowerLabel = label.toLowerCase();
        if (lowerLabel.contains('healthy')) {
          isHealthy = true;
          final words = label.split(RegExp(r'\s+'));
          if (words.length > 1) {
            plantName = _formatName(words[0]);
            diseaseName = 'Healthy';
          } else {
            plantName = 'Plant';
            diseaseName = 'Healthy';
          }
        } else {
          final words = label.split(RegExp(r'\s+'));
          if (words.length > 1) {
            plantName = _formatName(words[0]);
            diseaseName = _formatName(words.sublist(1).join(' '));
          } else {
            plantName = 'Plant';
            diseaseName = _formatName(label);
          }
        }
      }

      if (diseaseName.toLowerCase() == 'healthy') {
        isHealthy = true;
      }

      if (diseaseName.toLowerCase().contains('healthy')) {
        isHealthy = true;
      }

      final confidence = response.confidence ?? 0.0;

      final scan = ScanHistory(
        plantName: plantName,
        diseaseName: diseaseName,
        imagePath: imagePath,
        confidence: confidence,
        scanDate: DateTime.now(),
        isHealthy: isHealthy,
      );

      await _saveScanUseCase(scan);
    } catch (_) {
      // Fail silently to not crash prediction flow if saving fails
    }
  }

  String _formatName(String text) {
    return text
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) => word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ')
        .trim();
  }
}
