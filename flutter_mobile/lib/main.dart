import 'package:flutter/material.dart';
import 'package:flutter_mobile/config/router/app_route.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
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
    //TODO: Remove this line when you want to reset the onboarding state

    //sl<SharedPreferences>().setBool('hasSeenOnboarding', false);
    final bool hasSeenOnboarding =
        sl<SharedPreferences>().getBool('hasSeenOnboarding') ?? false;
    final GoRouter route = AppRouter(hasSeenOnboarding).router;
    return ScreenUtilInit(
      designSize: const Size(1080, 2400), // Set to your design's size
      minTextAdapt: true,
      builder: (context, child) => MaterialApp.router(
        title: 'AFYA',
        debugShowCheckedModeBanner: false,
        theme: theme(),
        routerConfig: route,
      ),
    );
  }
}
