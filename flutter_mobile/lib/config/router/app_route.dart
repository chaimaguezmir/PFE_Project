import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/injection_container.dart';
import 'package:flutter_mobile/presentation/bloc/login/login_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/signup/signup_cubit.dart';
import 'package:flutter_mobile/presentation/screens/auth/account_verification_screen.dart';
import 'package:flutter_mobile/presentation/screens/auth/signup_screen.dart';
import 'package:flutter_mobile/presentation/screens/home/home_screen.dart';
import 'package:flutter_mobile/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_mobile/presentation/screens/auth/login_screen.dart';

class AppRouter {
  AppRouter(this._hasSeenOnboarding);

  final bool _hasSeenOnboarding;

  String get initialLocation {
    if (_hasSeenOnboarding) {
      return AppRoutePath.signIn;
    } else {
      return AppRoutePath.onboarding;
    }
  }

  GoRouter get router => _router;

  late final GoRouter _router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            BlocProvider(create: (context) => sl<SignUpCubit>(), child: child),
        routes: [
          GoRoute(
            path: AppRoutePath.onboarding,
            name: AppRouteName.onboarding,
            builder: (_, _) => const OnboardingScreen(),
          ),

          GoRoute(
            path: AppRoutePath.signUp,
            name: AppRouteName.signUp,
            builder: (_, _) => const SignUpScreen(),
          ),
          GoRoute(
            path: AppRoutePath.accountVerification,
            name: AppRouteName.accountVerification,
            builder: (_, _) => const AccountVerificationScreen(),
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) =>
            BlocProvider(create: (context) => sl<LoginCubit>(), child: child),
        routes: [
          GoRoute(
            path: AppRoutePath.signIn,
            name: AppRouteName.signIn,
            builder: (_, _) => const LoginScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutePath.home,
        name: AppRouteName.home,
        builder: (_, _) => const HomeScreen(),
      ),
    ],
  );
}
