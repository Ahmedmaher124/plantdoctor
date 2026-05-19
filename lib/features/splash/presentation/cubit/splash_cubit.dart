import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final SharedPreferences sharedPreferences;

  SplashCubit({required this.sharedPreferences}) : super(SplashInitial());

  Future<void> initSplash() async {
    emit(SplashLoading());
    
    // Simulate initial loading/processing time (3 seconds)
    await Future.delayed(const Duration(seconds: 3));
    
    // Check if it is the first launch
    final isFirstLaunch = sharedPreferences.getBool('isFirstLaunch') ?? true;
    
    if (isFirstLaunch) {
      // It's the first launch; direct to Onboarding and set flag
      // Wait for onboarding to complete before setting this to false in reality,
      // but for architecture flow we'll leave it as a standard approach
      emit(SplashNavigateToOnboarding());
    } else {
      // Returning user; direct to Home
      emit(SplashNavigateToHome());
    }
  }
}
