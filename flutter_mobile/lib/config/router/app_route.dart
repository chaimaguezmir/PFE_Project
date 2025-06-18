import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
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
import 'package:flutter_mobile/presentation/screens/group/add_member_screen.dart';
import 'package:flutter_mobile/presentation/screens/group/group_membe_screen.dart';
import 'package:flutter_mobile/presentation/screens/group/group_screen.dart';
import 'package:flutter_mobile/presentation/screens/main_screen.dart';
import 'package:flutter_mobile/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter(this._hasSeenOnboarding, this._isAuthenticated);

  final bool _hasSeenOnboarding;
  final bool _isAuthenticated;

  String get initialLocation {
    if (_isAuthenticated) {
      return AppRoutePath.mainScreen;
    } else if (_hasSeenOnboarding) {
      return AppRoutePath.getStartedScreen;
    } else {
      return AppRoutePath.onboarding;
    }
  }

  GoRouter get router => _router;

  late final GoRouter _router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      // Onboarding Flow
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
      GoRoute(
        path: AppRoutePath.getStartedScreen,
        name: AppRouteName.getStartedScreen,
        builder: (_, _) => const GetStartedScreen(),
      ),
      // Login Flow
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
      GoRoute(
        path: AppRoutePath.mainScreen,
        name: AppRouteName.mainScreen,
        builder: (_, _) => const MainScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) =>
            BlocProvider(create: (context) => sl<GroupCubit>(), child: child),
        routes: [
          GoRoute(
            path: AppRoutePath.groupMembersScreen,
            name: AppRouteName.groupMembersScreen,
            builder: (context, state) {
              final selectedGroupId =
                  state.pathParameters['selectedGroupId'] ?? '';
              return GroupMembersScreen(selectedGroupId: selectedGroupId);
            },
          ),
          GoRoute(
            path: AppRoutePath.addMemberScreen,
            name: AppRouteName.addMemberScreen,
            builder: (_, _) => const AddMemberScreen(),
          ),
        ],
      ),
    ],
  );
}
