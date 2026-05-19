import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //---------------------------------------------------------
  // External
  //---------------------------------------------------------
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  //---------------------------------------------------------
  // Features - Splash
  //---------------------------------------------------------
  sl.registerFactory(() => SplashCubit(sharedPreferences: sl()));

  //---------------------------------------------------------
  // Features - Onboarding
  //---------------------------------------------------------
  sl.registerFactory(() => OnboardingCubit(sharedPreferences: sl()));
}
