import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../network/api_client.dart';
import '../../features/disease_prediction/data/repositories/disease_prediction_repository.dart';
import '../../features/disease_prediction/presentation/cubit/disease_prediction_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //---------------------------------------------------------
  // External
  //---------------------------------------------------------
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());

  //---------------------------------------------------------
  // Core
  //---------------------------------------------------------
  sl.registerLazySingleton(() => ApiClient(dio: sl()));

  //---------------------------------------------------------
  // Features - Splash
  //---------------------------------------------------------
  sl.registerFactory(() => SplashCubit(sharedPreferences: sl()));

  //---------------------------------------------------------
  // Features - Onboarding
  //---------------------------------------------------------
  sl.registerFactory(() => OnboardingCubit(sharedPreferences: sl()));

  //---------------------------------------------------------
  // Features - Settings
  //---------------------------------------------------------
  sl.registerLazySingleton(() => SettingsCubit(prefs: sl()));

  //---------------------------------------------------------
  // Features - Disease Prediction
  //---------------------------------------------------------
  sl.registerLazySingleton(() => DiseasePredictionRepository(apiClient: sl()));
  sl.registerFactory(() => DiseasePredictionCubit(repository: sl()));
}
