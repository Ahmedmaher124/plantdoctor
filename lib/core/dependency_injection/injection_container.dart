import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/gemini_chat/data/datasource/gemini_remote_datasource.dart';
import '../../features/gemini_chat/data/repositories/chat_repository_impl.dart';
import '../../features/gemini_chat/domain/repositories/chat_repository.dart';
import '../../features/gemini_chat/domain/usecases/send_message_usecase.dart';
import '../../features/gemini_chat/presentation/cubit/chat_cubit.dart';
import '../../features/disease_detection/data/datasource/disease_remote_datasource.dart';
import '../../features/disease_detection/data/repositories/disease_repository_impl.dart';
import '../../features/disease_detection/domain/repositories/disease_repository.dart';
import '../../features/disease_detection/domain/usecases/get_diseases_usecase.dart';
import '../../features/disease_detection/presentation/cubit/disease_cubit.dart';
import '../constants/api_keys.dart';
import '../network/gemini_dio_client.dart';
import '../network/api_client.dart';
import '../../features/disease_prediction/data/repositories/disease_prediction_repository.dart';
import '../../features/disease_prediction/presentation/cubit/disease_prediction_cubit.dart';

final sl = GetIt.instance;

const _plainDioName = 'plainDio';
const _geminiDioName = 'geminiDio';

Future<void> init() async {
  //---------------------------------------------------------
  // External
  //---------------------------------------------------------
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton<Dio>(() => Dio(), instanceName: _plainDioName);

  //---------------------------------------------------------
  // Core
  //---------------------------------------------------------
  sl.registerLazySingleton(
      () => ApiClient(dio: sl<Dio>(instanceName: _plainDioName)));

  // Dio — Gemini API client
  sl.registerLazySingleton<Dio>(
    () => GeminiDioClient.instance,
    instanceName: _geminiDioName,
  );

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
  // Features - Gemini Chat
  //---------------------------------------------------------

  // Data source
  sl.registerLazySingleton<GeminiRemoteDataSource>(
    () => GeminiRemoteDataSourceImpl(
      dio: sl<Dio>(instanceName: _geminiDioName),
      apiKey: ApiKeys.gemini,
    ),
  );

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl<GeminiRemoteDataSource>()),
  );

  // Use case
  sl.registerLazySingleton(
    () => SendMessageUseCase(sl<ChatRepository>()),
  );

  // Cubit — factory so each chat screen gets a fresh instance
  sl.registerFactory(
    () => ChatCubit(sendMessageUseCase: sl<SendMessageUseCase>()),
  );

  //---------------------------------------------------------
  // Features - Disease Detection
  //---------------------------------------------------------

  // Data source — uses a plain Dio (not the Gemini one)
  sl.registerLazySingleton<DiseaseRemoteDataSource>(
    () => DiseaseRemoteDataSourceImpl(
      dio: sl<Dio>(instanceName: _plainDioName),
      apiKey: ApiKeys.perenual,
    ),
  );

  // Repository
  sl.registerLazySingleton<DiseaseRepository>(
    () => DiseaseRepositoryImpl(sl<DiseaseRemoteDataSource>()),
  );

  // Use case
  sl.registerLazySingleton(
    () => GetDiseasesUseCase(sl<DiseaseRepository>()),
  );

  // Cubit — singleton so the disease list is cached across navigation
  sl.registerLazySingleton(
    () => DiseaseCubit(getDiseasesUseCase: sl<GetDiseasesUseCase>()),
  );
  // Features - Disease Prediction
  //---------------------------------------------------------
  sl.registerLazySingleton(() => DiseasePredictionRepository(apiClient: sl()));
  sl.registerFactory(() => DiseasePredictionCubit(repository: sl()));
}
