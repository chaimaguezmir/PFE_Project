import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/presentation/bloc/auth/auth/auth_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection_container.dart';

//WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
// FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final prefs = await SharedPreferences.getInstance();
  // final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
  // Initialize screen util first

  await ScreenUtil.ensureScreenSize();
  await initInjectionContainer();

  // runApp(MyApp(initialLocation: hasSeenOnboarding ? '/login' : '/onboarding'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: const MyAppView(),
    );
  }
}

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO: Remove this line when you want to reset the onboarding state

    sl<SharedPreferences>().setBool('hasSeenOnboarding', false);
    final bool hasSeenOnboarding =
        sl<SharedPreferences>().getBool('hasSeenOnboarding') ?? false;
    final token = sl<SharedPreferences>().getString('token');
    final bool isAuthenticated = token != null && token.isNotEmpty;
    final GoRouter route = AppRouter(hasSeenOnboarding, isAuthenticated).router;
    return ScreenUtilInit(
      designSize: const Size(411.4, 914.3),
      minTextAdapt: true,
      builder: (context, child) {

        return MaterialApp.router(
          title: 'AFYA',
          debugShowCheckedModeBanner: false,
          theme: theme(),
          routerConfig: route,
          builder: (context, child) {
            return BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                final messenger = ScaffoldMessenger.of(context);
                if (state.status == AuthStatus.noNetwork) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('No network connection'),
                      duration: Duration(days: 365),
                    ),
                  );
                } else if (state.status == AuthStatus.backOnLine) {
                  messenger.showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Back online'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  messenger.hideCurrentSnackBar();
                }
              },
              child: child!,
            );
          },
        );
      },
    );
  }
}
