import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/injection_container.dart';
import 'package:flutter_mobile/presentation/bloc/auth/forgot_password/forgot_password_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/auth/login/login_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/auth/signup/signup_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/group/group_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/home/prescription_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/profile/profile_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/services/services_cubit.dart';
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
import 'package:flutter_mobile/presentation/screens/home/prescription_detail_screen.dart';
import 'package:flutter_mobile/presentation/screens/home/prescriptions_screen.dart';
import 'package:flutter_mobile/presentation/screens/home/welcome_screen.dart';
import 'package:flutter_mobile/presentation/screens/bottom_bar.dart';

import 'package:flutter_mobile/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:flutter_mobile/presentation/screens/profile/profile_screen.dart';
import 'package:flutter_mobile/presentation/screens/services/add_medication_manually_screen.dart';
import 'package:flutter_mobile/presentation/screens/services/barcode_scanner_screen.dart';
import 'package:flutter_mobile/presentation/screens/services/medication_tracker_screen.dart';
import 'package:flutter_mobile/presentation/screens/services/pharmacy_box_screen.dart';
import 'package:flutter_mobile/presentation/screens/services/medicine_search_result_screen.dart';
import 'package:flutter_mobile/presentation/screens/services/services_screen.dart';
import 'package:go_router/go_router.dart';

import 'app_route_constants.dart';

class AppRouter {
  AppRouter(this._hasSeenOnboarding, this._isAuthenticated);

  final bool _hasSeenOnboarding;
  final bool _isAuthenticated;

  String get initialLocation {
    if (_isAuthenticated) {
      return AppRoutePath.services;
    } else if (_hasSeenOnboarding) {
      return AppRoutePath.signIn;
    } else {
      return AppRoutePath.onboarding;
    }
  }

  GoRouter get router => _router;
  late final GoRouter _router = GoRouter(
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

      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
            ) {
              // Return the widget that implements the custom shell (in this case
              // using a BottomNavigationBar). The StatefulNavigationShell is passed
              // to be able access the state of the shell and to navigate to other
              // branches in a stateful way.
              return BottomBar(navigationShell: navigationShell);
            },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              ShellRoute(
                builder: (context, state, child) => BlocProvider(
                  create: (context) => sl<PrescriptionCubit>(),
                  child: child,
                ),
                routes: [
                  GoRoute(
                    name: AppRouteName.home,
                    path: AppRoutePath.home,
                    builder: (context, state) =>  const WelcomeScreen(),
                  ),
                  GoRoute(
                    name: AppRouteName.prescription,
                    path: AppRoutePath.prescription,
                    builder: (context, state) =>  const PrescriptionsScreen(),
                  ),
                  GoRoute(
                    name: AppRouteName.prescriptionDetail,
                    path: AppRoutePath.prescriptionDetail,
                    builder: (context, state) =>  const PrescriptionDetailScreen(),
                  ),

                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              ShellRoute(
                builder: (context, state, child) => BlocProvider(
                  create: (context) => sl<ServicesCubit>()..fetchPharmacyBoxes(),
                  child: child,
                ),
                routes: [
                  GoRoute(
                    name: AppRouteName.services,
                    path: AppRoutePath.services,
                    builder: (context, state) =>  const ServicesScreen(),
                  ),
                  GoRoute(
                    name: AppRouteName.pharmacyBox,
                    path: AppRoutePath.pharmacyBox,
                    builder: (context, state) => const PharmacyBoxScreen(),
                  ),
                  GoRoute(
                    name: AppRouteName.barcodeScanner,
                    path: AppRoutePath.barcodeScanner,
                    builder: (context, state) => const BarcodeScannerScreen(),
                  ),
                  GoRoute(
                    name: AppRouteName.medicineSearchResult,
                    path: AppRoutePath.medicineSearchResult,
                    builder: (context, state) => const MedicineSearchResultScreen(),
                  ),

                  GoRoute(
                    name: AppRouteName.medicationTracker,
                    path: AppRoutePath.medicationTracker,
                    builder: (context, state) => const MedicationTrackerScreen(),
                  ),
                  GoRoute(
                    name: AppRouteName.addMedicationManually,
                    path: AppRoutePath.addMedicationManually,
                    builder: (context, state) => const AddMedicationManuallyScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              ShellRoute(
                builder: (context, state, child) => BlocProvider(
                  create: (context) => sl<GroupCubit>()..fetchGroups(),
                  child: child,
                ),
                routes: [
                  // Auth flow routes (onboarding, signup, login)
                  GoRoute(
                    name: AppRouteName.groupScreen,
                    path: AppRoutePath.groupScreen,
                    builder: (context, state) => const GroupScreen(),
                  ),
                  GoRoute(
                    name: AppRouteName.groupMembersScreen,
                    path: AppRoutePath.groupMembersScreen,
                    builder: (context, state) => const GroupMembersScreen(),
                  ),
                  GoRoute(
                    name: AppRouteName.addMemberScreen,
                    path: AppRoutePath.addMemberScreen,
                    builder: (context, state) => const AddMemberScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                name: 'profile',
                path: '/profile',
                builder: (context, state) => BlocProvider(
                  create: (context) => sl<ProfileCubit>(),
                  child: const ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),

      // Main app with bottom navigation (after login)
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
