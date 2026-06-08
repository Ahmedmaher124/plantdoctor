import 'package:flutter/material.dart';
import 'package:plantdoctor/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/dependency_injection/injection_container.dart' as di;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/routes/route_constants.dart';
import '../../../disease_prediction/presentation/cubit/disease_prediction_cubit.dart';
import '../../../disease_prediction/presentation/cubit/disease_prediction_state.dart';
import '../../../disease_prediction/presentation/pages/disease_result_screen.dart';
import '../widgets/home_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final categories = [
      _CategoryEntry(l10n.catApple, 'assets/icons/apple.png'),
      _CategoryEntry(l10n.catGrape, 'assets/icons/grape-fruit.png'),
      _CategoryEntry(l10n.catTomato, 'assets/icons/tomato.png'),
      _CategoryEntry(l10n.catPotato, 'assets/icons/potato.png'),
      _CategoryEntry(l10n.catCorn, 'assets/icons/corn.png'),
      _CategoryEntry(l10n.catPepper, 'assets/icons/bell-pepper.png'),
      _CategoryEntry(l10n.catCherry, 'assets/icons/cherries.png'),
      _CategoryEntry(l10n.catStrawberry, 'assets/icons/strawberry.png'),
      _CategoryEntry(l10n.catPeach, 'assets/icons/peach.png'),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteConstants.chat),
        backgroundColor: AppColors.primary,
        tooltip: 'Plant AI Chat',
        child: const Icon(Icons.chat_rounded, color: AppColors.white, size: 26),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────────
            HomeHeader(
              title: l10n.appTitle,
              subtitle: l10n.appSubtitle,
              searchHint: l10n.searchPlaceholder,
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Categories ──────────────────────────────────
                  Text(
                    l10n.categories,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTextStyles.fontFamily,
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      clipBehavior: Clip.none,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return CategoryItem(
                          title: cat.name,
                          iconPath: cat.iconPath,
                          bgColor: AppColors.surfaceLeaf,
                          iconColor: AppColors.iconLeaf,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(cat.name)),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Scan Card ───────────────────────────────────
                  ScanCard(
                    title: l10n.scanPlantNow,
                    subtitle: l10n.scanPlantDesc,
                    buttonText: l10n.openCamera,
                    onScanTap: () => _showImageSourceSheet(context),
                  ),
                  const SizedBox(height: 32),

                  // ── Featured ────────────────────────────────────
                  Text(
                    l10n.featured,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTextStyles.fontFamily,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // The red "Common Diseases" card is the visual entry
                  // point for the disease list — tap to navigate to
                  // the full /diseases screen. All disease logic,
                  // cubit, API and state remain completely unchanged.
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              context.push(RouteConstants.diseases),
                          child: FeaturedCard(
                            title: l10n.featCommonDiseases,
                            icon: Icons.trending_up,
                            bgColor: AppColors.surfacePink,
                            iconColor: AppColors.iconPink,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FeaturedCard(
                          title: l10n.featHealthyTips,
                          icon: Icons.favorite_border,
                          bgColor: AppColors.surfaceLeaf,
                          iconColor: AppColors.iconLeaf,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ── Recent Scans ────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.recentScans,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppTextStyles.fontFamily,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          l10n.seeAll,
                          style: AppTextStyles.subtitle.copyWith(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  RecentScanItem(
                    plantName: l10n.plantTomato,
                    diseaseName: 'Blight',
                    time: l10n.hoursAgo,
                    statusColor: AppColors.statusRed,
                    iconPath: 'assets/icons/tomato.png',
                  ),
                  RecentScanItem(
                    plantName: l10n.plantPotato,
                    diseaseName: 'Early Blight',
                    time: l10n.yesterday,
                    statusColor: AppColors.statusYellow,
                    iconPath: 'assets/icons/potato.png',
                  ),
                  RecentScanItem(
                    plantName: l10n.plantCorn,
                    diseaseName: 'Healthy',
                    time: l10n.threeDaysAgo,
                    statusColor: AppColors.statusGreen,
                    iconPath: 'assets/icons/corn.png',
                  ),
                  RecentScanItem(
                    plantName: l10n.plantPepper,
                    diseaseName: 'Bell Bacterial Spot',
                    time: l10n.fiveDaysAgo,
                    statusColor: AppColors.statusRed,
                    iconPath: 'assets/icons/bell-pepper.png',
                  ),

                  // Extra padding for FAB
                  const SizedBox(height: 64),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showImageSourceSheet(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.cameraSourceTitle,
                  style: AppTextStyles.h1.copyWith(fontSize: 16),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded),
                title: Text(l10n.cameraSourceTakePhoto),
                onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: Text(l10n.cameraSourceGallery),
                onTap: () => Navigator.of(sheetContext).pop(ImageSource.gallery),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (source == null) {
      return;
    }

    await _startPredictionFlow(context, source);
  }

  Future<void> _startPredictionFlow(BuildContext context, ImageSource source) async {
    final l10n = AppLocalizations.of(context)!;
    final cubit = di.sl<DiseasePredictionCubit>();

    final imageFile = await cubit.pickImage(source);
    if (imageFile == null) {
      _showFailure(context, cubit.state, l10n);
      await cubit.close();
      return;
    }

    _showLoadingDialog(context, l10n.cameraPredicting);
    final response = await cubit.predictWithImage(imageFile);
    Navigator.of(context, rootNavigator: true).pop();

    if (response != null) {
      await cubit.close();
      if (context.mounted) {
        context.push(
          RouteConstants.resultDetails,
          extra: DiseaseResultArgs(
            response: response,
            imagePath: imageFile.path,
          ),
        );
      }
      return;
    }

    _showFailure(context, cubit.state, l10n);
    await cubit.close();
  }

  void _showLoadingDialog(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          content: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
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
      },
    );
  }

  void _showFailure(
    BuildContext context,
    DiseasePredictionState state,
    AppLocalizations l10n,
  ) {
    if (state is! DiseasePredictionFailure) {
      return;
    }

    final message = _errorMessage(l10n, state.errorType);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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

class _CategoryEntry {
  final String name;
  final String iconPath;
  const _CategoryEntry(this.name, this.iconPath);
}
