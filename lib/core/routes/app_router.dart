import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'route_constants.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/settings/presentation/pages/settings_screen.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/gemini_chat/presentation/pages/chat_screen.dart';
import '../../features/gemini_chat/presentation/cubit/chat_cubit.dart';
import '../../features/disease_detection/presentation/pages/disease_list_screen.dart';
import '../../features/disease_detection/presentation/cubit/disease_cubit.dart';
import '../../features/disease_prediction/presentation/pages/disease_prediction_screen.dart';
import '../../features/disease_prediction/presentation/pages/disease_result_screen.dart';
import '../../features/disease_prediction/data/models/disease_prediction_response.dart';
import '../dependency_injection/injection_container.dart' as di;

final GoRouter appRouter = GoRouter(
  initialLocation: RouteConstants.splash,
  routes: [
    GoRoute(
      path: RouteConstants.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteConstants.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RouteConstants.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: RouteConstants.camera,
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Camera Screen'))),
    ),
    GoRoute(
      path: RouteConstants.result,
    
      builder: (context, state) => const DiseasePredictionScreen(),
    ),
    GoRoute(
      path: RouteConstants.result,
      builder: (context, state) {
        final response = state.extra;
        if (response is DiseaseResultArgs) {
          return DiseaseResultScreen(
            response: response.response,
            imagePath: response.imagePath,
          );
        }
        if (response is DiseasePredictionResponse) {
          return DiseaseResultScreen(response: response);
        }
        return const Scaffold(body: Center(child: Text('Result Screen')));
      },
    ),
    GoRoute(
      path: RouteConstants.chat,
      builder: (context, state) => BlocProvider(
        create: (_) => di.sl<ChatCubit>(),
        child: const ChatScreen(),
      ),
    ),
    GoRoute(
      path: RouteConstants.settings,
      builder: (context, state) => BlocProvider.value(
        value: di.sl<SettingsCubit>(),
        child: const SettingsScreen(),
      ),
    ),
    GoRoute(
      path: RouteConstants.diseases,
      builder: (context, state) => BlocProvider.value(
        value: di.sl<DiseaseCubit>(),
        child: const DiseaseListScreen(),
      ),
    ),
  ],
);
