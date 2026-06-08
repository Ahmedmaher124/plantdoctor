import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/routes/route_constants.dart';

class HomeHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String searchHint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const HomeHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.searchHint,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 64, bottom: 32),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.h1.copyWith(color: AppColors.white, fontSize: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.subtitle.copyWith(color: AppColors.white.withOpacity(0.9), fontSize: 14),
                  ),
                ],
              ),
              // Settings icon button
              GestureDetector(
                onTap: () => context.push(RouteConstants.settings),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.settings_rounded, color: AppColors.white, size: 22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                icon: const Icon(Icons.search, color: AppColors.textGrey),
                hintText: searchHint,
                hintStyle: AppTextStyles.subtitle.copyWith(fontSize: 14),
                border: InputBorder.none,
                suffixIcon: controller == null
                    ? null
                    : ValueListenableBuilder<TextEditingValue>(
                        valueListenable: controller!,
                        builder: (context, value, _) {
                          if (value.text.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.clear_rounded, color: AppColors.textGrey, size: 20),
                            onPressed: () {
                              controller!.clear();
                              onChanged?.call('');
                            },
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final String iconPath;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.title,
    required this.iconPath,
    required this.bgColor,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: AppColors.surfaceLeaf,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            splashColor: AppColors.iconLeaf.withOpacity(0.2),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              child: Image.asset(iconPath, fit: BoxFit.contain),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: AppTextStyles.subtitle.copyWith(
            fontSize: 12,
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class ScanCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onScanTap;

  const ScanCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onScanTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h1.copyWith(color: AppColors.white, fontSize: 20),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.subtitle.copyWith(color: AppColors.white.withOpacity(0.9), fontSize: 13),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onScanTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontFamily: AppTextStyles.fontFamily),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.camera_alt, color: AppColors.white, size: 32),
          ),
        ],
      ),
    );
  }
}

class FeaturedCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const FeaturedCard({
    super.key,
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.white, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyles.h1.copyWith(fontSize: 14, height: 1.3),
          ),
        ],
      ),
    );
  }
}

class RecentScanItem extends StatelessWidget {
  final String plantName;
  final String diseaseName;
  final String time;
  final Color statusColor;
  final String? iconPath;

  const RecentScanItem({
    super.key,
    required this.plantName,
    required this.diseaseName,
    required this.time,
    required this.statusColor,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.indicatorInactive.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceLeaf,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: iconPath != null 
                ? Image.asset(iconPath!, fit: BoxFit.contain)
                : const Icon(Icons.eco, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$plantName - $diseaseName",
                  style: AppTextStyles.h1.copyWith(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: AppColors.textGrey),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: AppTextStyles.subtitle.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
