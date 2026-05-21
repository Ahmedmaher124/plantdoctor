import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/gemini_chat/data/datasource/gemini_remote_datasource.dart';
import '../../features/gemini_chat/data/repositories/chat_repository_impl.dart';
import '../../features/gemini_chat/domain/repositories/chat_repository.dart';
import '../../features/gemini_chat/domain/usecases/send_message_usecase.dart';
import '../../features/gemini_chat/presentation/cubit/chat_cubit.dart';
import '../constants/api_keys.dart';
import '../network/gemini_dio_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //---------------------------------------------------------
  // External
  //---------------------------------------------------------
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Dio — Gemini API client
  sl.registerLazySingleton<Dio>(() => GeminiDioClient.instance);

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
      dio: sl<Dio>(),
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
}
