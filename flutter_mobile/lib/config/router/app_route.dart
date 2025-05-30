import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/auth/pages/login_page.dart';
import '../../presentation/onboarding/bloc/OnboardingCubit.dart';
import '../../presentation/onboarding/pages/onboarding_page.dart';

GoRouter router(String initialLocation) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => BlocProvider(
        create: (_) => OnboardingCubit(),
        child: OnboardingPage(),
      ),
    ),
    GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
    // … other routes …
  ],
);
