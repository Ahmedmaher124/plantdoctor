import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/routes/route_constants.dart';
import '../widgets/home_widgets.dart';

class PlantCategoryData {
  final String nameAr;
  final String nameEn;
  final String assetPath;
  final Color bgColor;
  final Color iconColor;

  PlantCategoryData(this.nameAr, this.nameEn, this.assetPath, this.bgColor, this.iconColor);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

    static final List<PlantCategoryData> _categories = [
    PlantCategoryData('تفاح', 'Apple', 'assets/icons/apple.png', AppColors.surfaceLeaf, AppColors.iconLeaf),
    PlantCategoryData('عنب', 'Grape', 'assets/icons/grape-fruit.png', AppColors.surfaceLeaf, AppColors.iconLeaf),
    PlantCategoryData('طماطم', 'Tomato', 'assets/icons/tomato.png', AppColors.surfaceLeaf, AppColors.iconLeaf),
    PlantCategoryData('بطاطس', 'Potato', 'assets/icons/potato.png', AppColors.surfaceLeaf, AppColors.iconLeaf),
    PlantCategoryData('ذرة', 'Corn', 'assets/icons/corn.png', AppColors.surfaceLeaf, AppColors.iconLeaf),
    PlantCategoryData('فلفل', 'Bell Pepper', 'assets/icons/bell-pepper.png', AppColors.surfaceLeaf, AppColors.iconLeaf),
    PlantCategoryData('كرز', 'Cherry', 'assets/icons/cherries.png', AppColors.surfaceLeaf, AppColors.iconLeaf),
    PlantCategoryData('فراولة', 'Strawberry', 'assets/icons/strawberry.png', AppColors.surfaceLeaf, AppColors.iconLeaf),
    PlantCategoryData('خوخ', 'Peach', 'assets/icons/peach.png', AppColors.surfaceLeaf, AppColors.iconLeaf),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteConstants.chat),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white, size: 28),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            const HomeHeader(
              title: AppStrings.appTitle,
              subtitle: AppStrings.appSubtitle,
              searchHint: AppStrings.searchPlaceholder,
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories Title
                  const Text(
                    AppStrings.categories,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: AppTextStyles.fontFamily),
                  ),
                  const SizedBox(height: 16),
                  
                  // Categories Horizontally Scrollable List
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      clipBehavior: Clip.none,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        return CategoryItem(
                          title: cat.nameAr, 
                          iconPath: cat.assetPath,
                          bgColor: cat.bgColor,
                          iconColor: cat.iconColor,
                          onTap: () {
                             // Handle category selection
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: Text('Selected: ${cat.nameAr} (${cat.nameEn})')),
                             );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Scan Card
                  ScanCard(
                    title: AppStrings.scanPlantNow,
                    subtitle: AppStrings.scanPlantDesc,
                    buttonText: AppStrings.openCamera,
                    onScanTap: () => context.push(RouteConstants.camera),
                  ),
                  const SizedBox(height: 32),
                  
                  // Featured Title
                  const Text(
                    AppStrings.featured,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: AppTextStyles.fontFamily),
                  ),
                  const SizedBox(height: 16),
                  
                  // Featured Cards Row
                  const Row(
                    children: [
                      Expanded(
                        child: FeaturedCard(
                          title: AppStrings.featCommonDiseases,
                          icon: Icons.trending_up,
                          bgColor: AppColors.surfacePink,
                          iconColor: AppColors.iconPink,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: FeaturedCard(
                          title: AppStrings.featHealthyTips,
                          icon: Icons.favorite_border,
                          bgColor: AppColors.surfaceLeaf,
                          iconColor: AppColors.iconLeaf,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Recent Scans Title & See All
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        AppStrings.recentScans,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: AppTextStyles.fontFamily),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          AppStrings.seeAll,
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
                  
                  // Recent Scans List mapped to supported ML plants only
                  const RecentScanItem(
                    plantName: AppStrings.plantTomato,
                    diseaseName: 'Blight',
                    time: '2 hours ago',
                    statusColor: AppColors.statusRed,
                    iconPath: 'assets/icons/tomato.png',
                  ),
                  const RecentScanItem(
                    plantName: AppStrings.plantPotato,
                    diseaseName: 'Early Blight',
                    time: 'Yesterday',
                    statusColor: AppColors.statusYellow,
                    iconPath: 'assets/icons/potato.png',
                  ),
                  const RecentScanItem(
                    plantName: AppStrings.plantCorn,
                    diseaseName: 'Healthy',
                    time: '3 days ago',
                    statusColor: AppColors.statusGreen,
                    iconPath: 'assets/icons/corn.png',
                  ),
                  const RecentScanItem(
                    plantName: AppStrings.plantPepper,
                    diseaseName: 'Bell Bacterial Spot',
                    time: '5 days ago',
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
