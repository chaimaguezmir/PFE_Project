import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/injection_container.dart';
import 'package:flutter_mobile/presentation/bloc/auth/forgot_password/forgot_password_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/auth/login/login_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/auth/signup/signup_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/group/group_cubit.dart';
import 'package:flutter_mobile/presentation/screens/auth/account_verification_screen.dart';
import 'package:flutter_mobile/presentation/screens/auth/forgot_password/forgot_password_code_screen.dart';
import 'package:flutter_mobile/presentation/screens/auth/forgot_password/forgot_password_email_screen.dart';
import 'package:flutter_mobile/presentation/screens/auth/forgot_password/forgot_password_new_password_screen.dart';
import 'package:flutter_mobile/presentation/screens/auth/forgot_password/forgot_password_success_screen.dart';
import 'package:flutter_mobile/presentation/screens/auth/get_started_screen.dart';
import 'package:flutter_mobile/presentation/screens/auth/login_screen.dart';
import 'package:flutter_mobile/presentation/screens/auth/signup_screen.dart';
import 'package:flutter_mobile/presentation/screens/home/welcome_screen.dart';
import 'package:flutter_mobile/presentation/screens/main_screen.dart';

import 'package:flutter_mobile/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:flutter_mobile/presentation/screens/profile/profile_screen.dart';
import 'package:flutter_mobile/presentation/screens/services/services_screen.dart';
import 'package:go_router/go_router.dart';

import 'app_route_constants.dart';
import 'groupe_shell_route.dart';

final _routeNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'AppRouteNavigatorKey',
);

class AppRouter {
  AppRouter(this._hasSeenOnboarding, this._isAuthenticated);

  final bool _hasSeenOnboarding;
  final bool _isAuthenticated;

  String get initialLocation {
    if (_isAuthenticated) {
      return '/accueil';
    } else if (_hasSeenOnboarding) {
      return AppRoutePath.getStartedScreen;
    } else {
      return AppRoutePath.onboarding;
    }
  }

  GoRouter get router => _router;
  late final GoRouter _router = GoRouter(
    navigatorKey: _routeNavigatorKey,
    initialLocation: initialLocation, // Start with onboarding
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            BlocProvider(create: (context) => sl<SignUpCubit>(), child: child),
        routes: [
          // Auth flow routes (onboarding, signup, login)
          GoRoute(
            path: AppRoutePath.onboarding,
            name: AppRouteName.onboarding,
            builder: (context, state) => const OnboardingScreen(),
          ),
          GoRoute(
            path: AppRoutePath.signUp,
            name: AppRouteName.signUp,
            builder: (context, state) => const SignUpScreen(),
          ),
          GoRoute(
            path: AppRoutePath.accountVerification,
            name: AppRouteName.accountVerification,
            builder: (context, state) => const AccountVerificationScreen(),
          ),
        ],
      ),
      // Main app with bottom navigation (after login)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainScreen(navigationShell: navigationShell),
        branches: [
          // Branch 1: Second tab (replace with your actual screen)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/accueil', // Update with your actual path
                name: 'accueil', // Update with your actual name
                builder: (context, state) => const WelcomeScreen(),
              ),
            ],
          ),

          // Branch 2: Third tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/services',
                name: 'services',
                builder: (context, state) => const ServicesScreen()

              ),
            ],
          ),
          // Branch 3: Groups tab - GroupShell handles internal navigation
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePath.groupScreen, // Main groups screen
                name: AppRouteName.groupScreen,
                builder: (context, state) => BlocProvider(
                  create: (context) => sl<GroupCubit>(),
                  child: const GroupShell(),
                ),
              ),
            ],
          ),

          // Branch 4: Fourth tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) =>
                    const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutePath.getStartedScreen,
        name: AppRouteName.getStartedScreen,
        builder: (_, _) => const GetStartedScreen(),
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

      // Forgot Password Flow
      ShellRoute(
        builder: (context, state, child) => BlocProvider(
          create: (context) => sl<ForgotPasswordCubit>(),
          child: child,
        ),
        routes: [
          GoRoute(
            path: AppRoutePath.forgotPasswordEmailScreen,
            name: AppRouteName.forgotPasswordEmailScreen,
            builder: (_, _) => const ForgotPasswordEmailScreen(),
          ),
          GoRoute(
            path: AppRoutePath.forgotPasswordCodeScreen,
            name: AppRouteName.forgotPasswordCodeScreen,
            builder: (_, _) => const ForgotPasswordCodeScreen(),
          ),
          GoRoute(
            path: AppRoutePath.forgotPasswordNewPasswordScreen,
            name: AppRouteName.forgotPasswordNewPasswordScreen,
            builder: (_, _) => const ForgotPasswordNewPasswordScreen(),
          ),
          GoRoute(
            path: AppRoutePath.forgotPasswordSuccessScreen,
            name: AppRouteName.forgotPasswordSuccessScreen,
            builder: (_, _) => const ForgotPasswordSuccessScreen(),
          ),
        ],
      ),

      // Home Flow
    ],
  );
}
