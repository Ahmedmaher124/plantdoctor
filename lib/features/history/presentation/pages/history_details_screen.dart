import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:plantdoctor/l10n/app_localizations.dart';

import '../../../../core/routes/route_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/scan_history_model.dart';
import '../cubit/history_cubit.dart';

class ScanHistoryDetailsScreen extends StatelessWidget {
  final ScanHistoryModel scan;

  const ScanHistoryDetailsScreen({
    super.key,
    required this.scan,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final formattedDate = DateFormat('dd MMM yyyy', locale).format(scan.scanDate);
    final statusColor = _getStatusColor();
    final statusText = _getStatusText(l10n);

    final confidencePercent = scan.confidence <= 1.0
        ? scan.confidence * 100
        : scan.confidence;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Custom Silver AppBar with large image
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'scan-img-${scan.key}',
                child: _buildImage(),
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Diagnosis Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.cameraPredictionLabel,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: AppColors.textGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          scan.plantName,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          scan.diseaseName,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),
                        // Badge status and details grid
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Health Status Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: statusColor.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    statusText,
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Date
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: AppColors.textGrey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Metadata Grid Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Confidence Score
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                l10n.cameraPredictionConfidence,
                                style: const TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  color: AppColors.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${confidencePercent.toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  color: AppColors.primary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 48,
                          color: AppColors.indicatorInactive.withOpacity(0.4),
                        ),
                        // Healthy indicator
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                l10n.statusLabel,
                                style: const TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  color: AppColors.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Icon(
                                scan.isHealthy
                                    ? Icons.check_circle_rounded
                                    : Icons.warning_rounded,
                                color: statusColor,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Bottom Action Buttons
                  ElevatedButton.icon(
                    onPressed: () {
                      final prompt = l10n.historyTreatmentPrompt(
                        scan.plantName,
                        scan.diseaseName,
                      );
                      context.push(
                        RouteConstants.chat,
                        extra: prompt,
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline_rounded),
                    label: Text(l10n.cameraGetTreatment),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => _showDeleteConfirmation(context, l10n),
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: Text(l10n.delete),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.red,
                      side: const BorderSide(color: AppColors.red),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (scan.imagePath.isNotEmpty) {
      final file = File(scan.imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
        );
      }
    }
    return Container(
      color: AppColors.lightGreen,
      child: const Center(
        child: Icon(
          Icons.eco_rounded,
          color: AppColors.primary,
          size: 84,
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (scan.isHealthy) {
      return AppColors.statusGreen;
    }
    final lower = scan.diseaseName.toLowerCase();
    if (lower.contains('early') || lower.contains('warning') || lower.contains('suspected')) {
      return AppColors.statusYellow;
    }
    return AppColors.statusRed;
  }

  String _getStatusText(AppLocalizations l10n) {
    if (scan.isHealthy) {
      return l10n.statusHealthy;
    }
    final lower = scan.diseaseName.toLowerCase();
    if (lower.contains('early') || lower.contains('warning') || lower.contains('suspected')) {
      return l10n.statusWarning;
    }
    return l10n.statusDisease;
  }
}

void _showDeleteConfirmation(BuildContext context, AppLocalizations l10n) {
  final scan = context.findAncestorWidgetOfExactType<ScanHistoryDetailsScreen>()?.scan;
  if (scan == null) return;

  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(
          l10n.historyDeleteSingleConfirmTitle,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          l10n.historyDeleteSingleConfirmMessage,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              l10n.cancel,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.textGrey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Perform deletion
              context.read<HistoryCubit>().deleteScan(scan.key);
              Navigator.of(dialogContext).pop(); // pop dialog
              context.pop(); // pop screen back to list
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.scanDeleted,
                    style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
                  ),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              l10n.delete,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
