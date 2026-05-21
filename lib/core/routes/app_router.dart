import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'route_constants.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/settings/presentation/pages/settings_screen.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
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
      builder: (context, state) => const Scaffold(body: Center(child: Text('Camera Screen'))),
    ),
    GoRoute(
      path: RouteConstants.result,
      builder: (context, state) => const Scaffold(body: Center(child: Text('Result Screen'))),
    ),
    GoRoute(
      path: RouteConstants.chat,
      builder: (context, state) => const Scaffold(body: Center(child: Text('Chat Screen'))),
    ),
    GoRoute(
      path: RouteConstants.settings,
      builder: (context, state) => BlocProvider.value(
        value: di.sl<SettingsCubit>(),
        child: const SettingsScreen(),
      ),
    ),
  ],
);
