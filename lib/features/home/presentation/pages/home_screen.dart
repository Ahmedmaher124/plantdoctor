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
import '../../../history/data/models/scan_history_model.dart';
import '../../../history/presentation/widgets/scan_history_card.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget buildHighlightedText(String text, String query, TextStyle baseStyle, TextStyle highlightStyle) {
    if (query.isEmpty) {
      return Text(text, style: baseStyle);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);
    if (index == -1) {
      return Text(text, style: baseStyle);
    }

    final before = text.substring(0, index);
    final matched = text.substring(index, index + query.length);
    final after = text.substring(index + query.length);

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: before),
          TextSpan(text: matched, style: highlightStyle),
          TextSpan(text: after),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final categories = [
      _CategoryEntry(
        englishName: 'Apple',
        arabicName: 'تفاح',
        iconPath: 'assets/icons/apple.png',
        localizedNameSelector: (l10n) => l10n.catApple,
      ),
      _CategoryEntry(
        englishName: 'Grape',
        arabicName: 'عنب',
        iconPath: 'assets/icons/grape-fruit.png',
        localizedNameSelector: (l10n) => l10n.catGrape,
      ),
      _CategoryEntry(
        englishName: 'Tomato',
        arabicName: 'طماطم',
        iconPath: 'assets/icons/tomato.png',
        localizedNameSelector: (l10n) => l10n.catTomato,
      ),
      _CategoryEntry(
        englishName: 'Potato',
        arabicName: 'بطاطس',
        iconPath: 'assets/icons/potato.png',
        localizedNameSelector: (l10n) => l10n.catPotato,
      ),
      _CategoryEntry(
        englishName: 'Corn',
        arabicName: 'ذرة',
        iconPath: 'assets/icons/corn.png',
        localizedNameSelector: (l10n) => l10n.catCorn,
      ),
      _CategoryEntry(
        englishName: 'Bell Pepper',
        arabicName: 'فلفل',
        iconPath: 'assets/icons/bell-pepper.png',
        localizedNameSelector: (l10n) => l10n.catPepper,
      ),
      _CategoryEntry(
        englishName: 'Cherry',
        arabicName: 'كرز',
        iconPath: 'assets/icons/cherries.png',
        localizedNameSelector: (l10n) => l10n.catCherry,
      ),
      _CategoryEntry(
        englishName: 'Strawberry',
        arabicName: 'فراولة',
        iconPath: 'assets/icons/strawberry.png',
        localizedNameSelector: (l10n) => l10n.catStrawberry,
      ),
      _CategoryEntry(
        englishName: 'Peach',
        arabicName: 'خوخ',
        iconPath: 'assets/icons/peach.png',
        localizedNameSelector: (l10n) => l10n.catPeach,
      ),
    ];

    final filteredCategories = <_CategoryEntry>[];
    if (_searchQuery.isEmpty) {
      filteredCategories.addAll(categories);
    } else {
      final queryNormalized = _searchQuery.trim().toLowerCase();
      
      final matches = categories.where((cat) {
        final ar = cat.arabicName.toLowerCase();
        final en = cat.englishName.toLowerCase();
        return ar.contains(queryNormalized) || en.contains(queryNormalized);
      }).toList();

      matches.sort((a, b) {
        final aAr = a.arabicName.toLowerCase();
        final aEn = a.englishName.toLowerCase();
        final bAr = b.arabicName.toLowerCase();
        final bEn = b.englishName.toLowerCase();

        bool startsWith(String name) => name.startsWith(queryNormalized);
        bool isExact(String name) => name == queryNormalized;

        final aExact = isExact(aAr) || isExact(aEn);
        final bExact = isExact(bAr) || isExact(bEn);
        if (aExact && !bExact) return -1;
        if (!aExact && bExact) return 1;

        final aStarts = startsWith(aAr) || startsWith(aEn);
        final bStarts = startsWith(bAr) || startsWith(bEn);
        if (aStarts && !bStarts) return -1;
        if (!aStarts && bStarts) return 1;

        return 0;
      });

      filteredCategories.addAll(matches);
    }

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
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axisAlignment: -1.0,
                    child: child,
                  ),
                );
              },
              child: _searchQuery.isEmpty
                  ? _buildNormalDashboard(context, categories, l10n)
                  : _buildSearchResults(filteredCategories, l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNormalDashboard(BuildContext context, List<_CategoryEntry> categories, AppLocalizations l10n) {
    return Padding(
      key: const ValueKey('normal_view'),
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
                final name = cat.localizedNameSelector(l10n);
                return CategoryItem(
                  title: name,
                  iconPath: cat.iconPath,
                  bgColor: AppColors.surfaceLeaf,
                  iconColor: AppColors.iconLeaf,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(name)),
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
                child: GestureDetector(
                  onTap: () => context.push(RouteConstants.plantCareTips),
                  child: FeaturedCard(
                    title: l10n.featHealthyTips,
                    icon: Icons.favorite_border,
                    bgColor: AppColors.surfaceLeaf,
                    iconColor: AppColors.iconLeaf,
                  ),
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
                onPressed: () => context.push(RouteConstants.scanHistory),
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

          ValueListenableBuilder<Box<ScanHistoryModel>>(
            valueListenable: di.sl<Box<ScanHistoryModel>>().listenable(),
            builder: (context, box, _) {
              final scans = box.values.toList();
              if (scans.isEmpty) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.history_rounded,
                          size: 48,
                          color: AppColors.textGrey.withOpacity(0.4),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.historyEmptyState,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: AppColors.textGrey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Sort newest first
              scans.sort((a, b) => b.scanDate.compareTo(a.scanDate));

              // Take 5 items
              final latestScans = scans.take(5).toList();

              return Column(
                children: latestScans.map((scan) {
                  return ScanHistoryCard(
                    scan: scan,
                    onTap: () {
                      context.push(
                        RouteConstants.scanHistoryDetails,
                        extra: scan,
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),

          // Extra padding for FAB
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<_CategoryEntry> matches, AppLocalizations l10n) {
    final resultsTitle = l10n.localeName == 'ar' ? 'نتائج البحث' : 'Search Results';
    return Padding(
      key: const ValueKey('search_view'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            resultsTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: AppTextStyles.fontFamily,
            ),
          ),
          const SizedBox(height: 16),
          
          if (matches.isEmpty)
            _buildNoResults(l10n)
          else if (matches.length == 1)
            _buildProminentCard(matches.first, _searchQuery, l10n)
          else
            _buildSearchResultList(matches, _searchQuery, l10n),
          
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget _buildNoResults(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 64,
              color: AppColors.textGrey,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.homeNoPlantsFound,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
                fontFamily: AppTextStyles.fontFamily,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.homeTryAnotherSearch,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textGrey,
                fontFamily: AppTextStyles.fontFamily,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProminentCard(_CategoryEntry cat, String query, AppLocalizations l10n) {
    final name = cat.localizedNameSelector(l10n);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Container(
          width: 240,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceLeaf,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  cat.iconPath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              buildHighlightedText(
                name,
                query,
                const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                  fontFamily: AppTextStyles.fontFamily,
                ),
                const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontFamily: AppTextStyles.fontFamily,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cat.englishName,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textGrey,
                  fontFamily: AppTextStyles.fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResultList(List<_CategoryEntry> matches, String query, AppLocalizations l10n) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: matches.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final cat = matches[index];
        final name = cat.localizedNameSelector(l10n);
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceLeaf,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                cat.iconPath,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
            title: buildHighlightedText(
              name,
              query,
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
                fontFamily: AppTextStyles.fontFamily,
              ),
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                fontFamily: AppTextStyles.fontFamily,
              ),
            ),
            subtitle: Text(
              cat.englishName,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textGrey,
                fontFamily: AppTextStyles.fontFamily,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.primary),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(name)),
              );
            },
          ),
        );
      },
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
  final String englishName;
  final String arabicName;
  final String iconPath;
  final String Function(AppLocalizations) localizedNameSelector;

  const _CategoryEntry({
    required this.englishName,
    required this.arabicName,
    required this.iconPath,
    required this.localizedNameSelector,
  });
}
