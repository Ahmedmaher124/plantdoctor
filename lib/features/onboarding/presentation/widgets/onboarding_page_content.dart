import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingPageContent extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final Widget fallbackIcon;

  const OnboardingPageContent({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image Container with approximate UI if asset is missing
        Container(
          height: 300,
          width: double.infinity,
          alignment: Alignment.center,
          child: Image.asset(
            imagePath,
            height: 250,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => _buildFallbackUI(),
          ),
        ),
        const SizedBox(height: AppSpacing.s32),
        Text(
          title,
          style: AppTextStyles.h1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.s16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s32),
          child: Text(
            description,
            style: AppTextStyles.subtitle,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackUI() {
    // This draws a circle with an icon matching the designs roughly 
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        border: Border.all(
          color: title.contains('Smart') ? AppColors.secondaryTeal : AppColors.primary,
          width: 24,
        ),
        boxShadow: [
          BoxShadow(
            color: (title.contains('Smart') ? AppColors.secondaryTeal : AppColors.primary).withOpacity(0.15),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: fallbackIcon,
      ),
    );
  }
}
