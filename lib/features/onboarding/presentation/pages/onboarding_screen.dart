import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantdoctor/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/route_constants.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/onboarding_page_content.dart';
import '../widgets/onboarding_indicator.dart';
import '../widgets/onboarding_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OnboardingCubit>(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocConsumer<OnboardingCubit, OnboardingState>(
          listener: (context, state) {
            if (state is OnboardingCompleted) {
              context.go(RouteConstants.home);
            }
          },
          builder: (context, state) {
            final cubit = context.read<OnboardingCubit>();
            return Column(
              children: [
                // Top Action Bar (Skip)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s24, vertical: AppSpacing.s16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (state.currentPage < 2)
                        TextButton(
                          onPressed: () => cubit.skipToLast(),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.textGrey,
                          ),
                          child: Text(l10n.skip, style: AppTextStyles.skipText),
                        )
                      else
                        const SizedBox(height: 48),
                    ],
                  ),
                ),

                // PageView
                Expanded(
                  child: PageView(
                    controller: cubit.pageController,
                    onPageChanged: cubit.onPageChanged,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      OnboardingPageContent(
                        imagePath: AppAssets.onboarding1,
                        title: l10n.onboarding1Title,
                        description: l10n.onboarding1Desc,
                        fallbackIcon: const Icon(Icons.eco_outlined,
                            size: 80, color: AppColors.primary),
                      ),
                      OnboardingPageContent(
                        imagePath: AppAssets.onboarding2,
                        title: l10n.onboarding2Title,
                        description: l10n.onboarding2Desc,
                        fallbackIcon: const Icon(Icons.camera_alt_outlined,
                            size: 80, color: AppColors.primary),
                      ),
                      OnboardingPageContent(
                        imagePath: AppAssets.onboarding3,
                        title: l10n.onboarding3Title,
                        description: l10n.onboarding3Desc,
                        fallbackIcon: const Icon(Icons.chat_bubble_outline,
                            size: 80, color: AppColors.secondaryTeal),
                      ),
                    ],
                  ),
                ),

                // Bottom Area (Indicators & Button)
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.s24),
                  child: Column(
                    children: [
                      OnboardingIndicator(currentPage: state.currentPage),
                      const SizedBox(height: AppSpacing.s32),
                      OnboardingButton(
                        text: state.currentPage == 2
                            ? l10n.getStarted
                            : l10n.next,
                        onPressed: () => cubit.nextPage(),
                      ),
                      const SizedBox(height: AppSpacing.s16),
                    ],
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
