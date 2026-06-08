import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantdoctor/l10n/app_localizations.dart';

import 'package:go_router/go_router.dart';
import '../../../../core/routes/route_constants.dart';
import '../../../../core/dependency_injection/injection_container.dart' as di;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/disease_prediction_response.dart';
import '../cubit/disease_prediction_cubit.dart';
import '../cubit/disease_prediction_state.dart';
import 'disease_result_screen.dart';

class DiseasePredictionScreen extends StatelessWidget {
  const DiseasePredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<DiseasePredictionCubit>(),
      child: const _DiseasePredictionView(),
    );
  }
}

class _DiseasePredictionView extends StatefulWidget {
  const _DiseasePredictionView();

  @override
  State<_DiseasePredictionView> createState() => _DiseasePredictionViewState();
}

class _DiseasePredictionViewState extends State<_DiseasePredictionView> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.cameraTitle,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<DiseasePredictionCubit, DiseasePredictionState>(
        listener: (context, state) {
          if (state is DiseasePredictionSuccess) {
            context.push(
              RouteConstants.resultDetails,
              extra: DiseaseResultArgs(
                response: state.response,
                imagePath: state.imageFile?.path,
              ),
            );
          }
        },
        child: BlocBuilder<DiseasePredictionCubit, DiseasePredictionState>(
        builder: (context, state) {
          final imageFile = state.imageFile;
          final isLoading = state is DiseasePredictionLoading;
          final response = state is DiseasePredictionSuccess ? state.response : null;
          final errorType = state is DiseasePredictionFailure ? state.errorType : null;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ImagePreview(imageFile: imageFile),
                const SizedBox(height: 16),
                if (isLoading) ...[
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.cameraPredicting,
                        style: AppTextStyles.subtitle.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                if (response != null) ...[
                  _PredictionCard(response: response),
                  const SizedBox(height: 16),
                ],
                if (errorType != null) ...[
                  _ErrorCard(message: _errorMessage(l10n, errorType)),
                  const SizedBox(height: 16),
                ],
                const Spacer(),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => context.read<DiseasePredictionCubit>().captureAndPredict(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    imageFile == null ? l10n.cameraCapture : l10n.cameraRetake,
                    style: AppTextStyles.buttonText,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: isLoading
                      ? null
                      : () => context.read<DiseasePredictionCubit>().pickFromGallery(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.cameraGallery,
                    style: AppTextStyles.subtitle.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (!isLoading && errorType != null && imageFile != null)
                  OutlinedButton(
                    onPressed: () => context.read<DiseasePredictionCubit>().predictWithImage(imageFile),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.cameraTryAgain,
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

  String _errorMessage(AppLocalizations l10n, DiseasePredictionErrorType type) {
    switch (type) {
      case DiseasePredictionErrorType.noInternet:
        return l10n.errorNoInternet;
      case DiseasePredictionErrorType.timeout:
        return l10n.errorTimeout;
      case DiseasePredictionErrorType.server:
        return l10n.errorServer;
      case DiseasePredictionErrorType.invalidResponse:
        return l10n.errorInvalidResponse;
      case DiseasePredictionErrorType.cameraPermissionDenied:
        return l10n.errorCameraPermissionDenied;
      case DiseasePredictionErrorType.galleryPermissionDenied:
        return l10n.errorGalleryPermissionDenied;
      case DiseasePredictionErrorType.cameraCancelled:
        return l10n.errorCameraCancelled;
      case DiseasePredictionErrorType.unknown:
        return l10n.errorUnexpected;
    }
  }
}

class _ImagePreview extends StatelessWidget {
  final File? imageFile;

  const _ImagePreview({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.indicatorInactive.withOpacity(0.4)),
      ),
      child: imageFile == null
          ? Center(
              child: Text(
                l10n.cameraNoImage,
                style: AppTextStyles.subtitle.copyWith(fontSize: 14),
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                imageFile!,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
    );
  }
}

class _PredictionCard extends StatelessWidget {
  final DiseasePredictionResponse response;

  const _PredictionCard({required this.response});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = response.label ?? l10n.cameraPredictionUnknown;
    final confidence = response.confidence;
    final confidencePercent = confidence == null
      ? null
      : (confidence > 1 ? confidence : confidence * 100);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.indicatorInactive.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.cameraPredictionResult,
            style: AppTextStyles.h1.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.cameraPredictionLabel}: $label',
            style: AppTextStyles.subtitle.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 6),
          if (confidence != null)
            Text(
              '${l10n.cameraPredictionConfidence}: ${confidencePercent!.toStringAsFixed(1)}%',
              style: AppTextStyles.subtitle.copyWith(fontSize: 14),
            ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfacePink,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.iconPink.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.iconPink),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.subtitle.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
