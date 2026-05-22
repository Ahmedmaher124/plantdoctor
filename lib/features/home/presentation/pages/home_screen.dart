import 'package:flutter/material.dart';
import 'package:plantdoctor/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/routes/route_constants.dart';
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
                    onScanTap: () => context.push(RouteConstants.camera),
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
}

class _CategoryEntry {
  final String name;
  final String iconPath;
  const _CategoryEntry(this.name, this.iconPath);
}
