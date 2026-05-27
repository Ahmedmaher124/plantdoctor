import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plantdoctor/l10n/app_localizations.dart';

import '../../../../core/routes/route_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/disease_prediction_response.dart';

class DiseaseResultArgs {
  final DiseasePredictionResponse response;
  final String? imagePath;

  const DiseaseResultArgs({
    required this.response,
    this.imagePath,
  });
}

class DiseaseResultScreen extends StatelessWidget {
  final DiseasePredictionResponse response;
  final String? imagePath;

  const DiseaseResultScreen({
    super.key,
    required this.response,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = response.label ?? l10n.cameraPredictionUnknown;
    final confidence = response.confidence;
    final confidencePercent = confidence == null
        ? null
        : (confidence > 1 ? confidence : confidence * 100);
    final gaugeValue = confidencePercent == null
      ? null
      : (confidencePercent / 100).clamp(0, 1).toDouble();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          l10n.cameraPredictionResult,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ImageCard(
                      imagePath: imagePath,
                      onViewImage: imagePath == null
                          ? null
                          : () => _showImagePreview(context, imagePath!),
                    ),
                    const SizedBox(height: 12),
                    _DiagnosisCard(label: label),
                    const SizedBox(height: 12),
                    _ConfidenceCard(
                      confidencePercent: confidencePercent,
                      gaugeValue: gaugeValue,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            _BottomActions(
              onRetry: () => context.pop(),
              onBackHome: () => context.go(RouteConstants.home),
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePreview(BuildContext context, String path) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              File(path),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

class _ImageCard extends StatelessWidget {
  final String? imagePath;
  final VoidCallback? onViewImage;

  const _ImageCard({
    required this.imagePath,
    required this.onViewImage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            SizedBox(
              height: 210,
              width: double.infinity,
              child: imagePath == null
                  ? Container(
                      color: AppColors.indicatorInactive.withOpacity(0.2),
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 40,
                          color: AppColors.textGrey,
                        ),
                      ),
                    )
                  : Image.file(
                      File(imagePath!),
                      fit: BoxFit.cover,
                    ),
            ),
            if (onViewImage != null)
              Positioned(
                left: 12,
                bottom: 12,
                child: ElevatedButton.icon(
                  onPressed: onViewImage,
                  icon: const Icon(Icons.open_in_full_rounded, size: 18),
                  label: Text(l10n.cameraViewImage),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.55),
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: AppTextStyles.subtitle.copyWith(
                      color: AppColors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DiagnosisCard extends StatelessWidget {
  final String label;

  const _DiagnosisCard({required this.label});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.cameraPredictionLabel,
                  style: AppTextStyles.subtitle.copyWith(
                    fontSize: 12,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: AppTextStyles.h1.copyWith(fontSize: 22),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_florist_rounded, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _ConfidenceCard extends StatelessWidget {
  final double? confidencePercent;
  final double? gaugeValue;

  const _ConfidenceCard({
    required this.confidencePercent,
    required this.gaugeValue,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final percentText = confidencePercent == null
        ? '--'
        : '${confidencePercent!.toStringAsFixed(1)}%';
    final confidenceLabel = _confidenceText(l10n, gaugeValue);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            l10n.cameraPredictionConfidence,
            style: AppTextStyles.subtitle.copyWith(
              fontSize: 12,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            percentText,
            style: AppTextStyles.h1.copyWith(
              fontSize: 24,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            confidenceLabel,
            style: AppTextStyles.subtitle.copyWith(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (gaugeValue != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: gaugeValue,
                minHeight: 6,
                backgroundColor: AppColors.indicatorInactive.withOpacity(0.35),
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _confidenceText(AppLocalizations l10n, double? value) {
    if (value == null) {
      return l10n.cameraConfidenceUnknown;
    }
    if (value >= 0.9) {
      return l10n.cameraConfidenceVeryHigh;
    }
    if (value >= 0.75) {
      return l10n.cameraConfidenceHigh;
    }
    if (value >= 0.5) {
      return l10n.cameraConfidenceMedium;
    }
    return l10n.cameraConfidenceLow;
  }
}

class _SemiCircularGauge extends StatelessWidget {
  final double value;
  final String percentText;

  const _SemiCircularGauge({
    required this.value,
    required this.percentText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 100,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: 0.5,
              child: SizedBox(
                width: 170,
                height: 170,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: 1,
                      strokeWidth: 10,
                      color: AppColors.indicatorInactive,
                    ),
                    CircularProgressIndicator(
                      value: value,
                      strokeWidth: 10,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 6,
            child: Text(
              percentText,
              style: AppTextStyles.h1.copyWith(
                fontSize: 22,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onBackHome;

  const _BottomActions({
    required this.onRetry,
    required this.onBackHome,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final useColumn = constraints.maxWidth < 360;

            if (useColumn) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(l10n.cameraRetryDiagnosis),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: AppTextStyles.buttonText.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: onBackHome,
                    icon: const Icon(Icons.home_rounded),
                    label: Text(l10n.cameraBackHome),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: AppTextStyles.buttonText,
                    ),
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(l10n.cameraRetryDiagnosis),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: AppTextStyles.buttonText.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onBackHome,
                    icon: const Icon(Icons.home_rounded),
                    label: Text(l10n.cameraBackHome),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: AppTextStyles.buttonText,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
