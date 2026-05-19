import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/route_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SplashCubit>()..initSplash(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashNavigateToOnboarding) {
            context.go(RouteConstants.onboarding);
          } else if (state is SplashNavigateToHome) {
            context.go(RouteConstants.home);
          }
        },
        child: Scaffold(
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.gradientStart,
                  AppColors.gradientEnd,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                // Logo Container from design
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    // Stack for the leaf icon and red plus badge representing "Plant Doctor"
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Placeholder for the exact icon to be loaded manually
                        Image.asset(
                          'assets/images/splash_logo.png',
                          width: 60,
                          height: 60,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback to approximate look if asset isn't added yet
                            return Stack(
                              children: [
                                const Icon(
                                  Icons.eco_outlined,
                                  color: AppColors.primary,
                                  size: 60,
                                ),
                                Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: AppColors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.add,
                                      color: AppColors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                
                // Title
                const Text(
                  'Plant Doctor',
                  style: TextStyle(
                    fontFamily: 'Cairo', // Same Arabic font used in main.dart
                    fontSize: 32.0,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8.0),
                
                // Subtitle
                const Text(
                  'AI-Powered Plant Care',
                  style: TextStyle(
                    fontFamily: 'Cairo', // Using same family, robust for RTL environments
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                    letterSpacing: 0.2,
                  ),
                ),
                
                const Spacer(),
                
                // 3 Dots Loading Indicator equivalent based on UI
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDot(active: true),
                    const SizedBox(width: 8),
                    _buildDot(active: false),
                    const SizedBox(width: 8),
                    _buildDot(active: false),
                  ],
                ),
                const SizedBox(height: 48.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDot({required bool active}) {
    return Container(
      width: active ? 10 : 8,
      height: active ? 10 : 8,
      decoration: BoxDecoration(
        color: active ? AppColors.white : AppColors.white.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
    );
  }
}
