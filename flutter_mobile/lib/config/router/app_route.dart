import 'package:flutter_mobile/presentation/screens/auth/signup_screen.dart';
import 'package:flutter_mobile/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/auth/login_screen.dart';

class AppRouter {
  AppRouter(this._hasSeenOnboarding);

  final bool _hasSeenOnboarding;

  String get initialLocation {
    if (_hasSeenOnboarding) {
      return '/signup';
    } else {
      return '/onboarding';
    }
  }

  GoRouter get router => _router;

  late final GoRouter _router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (_, _) => const SignUpScreen()),
    ],
  );
}
