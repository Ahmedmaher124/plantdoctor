import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final SharedPreferences sharedPreferences;
  late final PageController pageController;

  OnboardingCubit({required this.sharedPreferences}) : super(const OnboardingInitial()) {
    pageController = PageController();
  }

  void onPageChanged(int page) {
    emit(OnboardingPageChanged(page));
  }

  Future<void> completeOnboarding() async {
    await sharedPreferences.setBool('isFirstLaunch', false);
    emit(const OnboardingCompleted());
  }

  void nextPage() {
    if (state.currentPage < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void skipToLast() {
    pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
