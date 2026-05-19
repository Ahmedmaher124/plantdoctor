import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'route_constants.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';

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
  ],
);
