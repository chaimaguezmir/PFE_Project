import 'package:flutter/material.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../widgets/onboarding_item.dart';

class IntroScreen1 extends StatelessWidget {
  final OnboardingItem item;
  const IntroScreen1({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment(0.75, 0.25),
                child: GestureDetector(
                  onTap: () {
                    GoRouter.of(context).push('/login');
                  },
                  child: Text(
                    "skip",
                    style: TextStyle(fontSize: 40.sp, color: Colors.green),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'lib/config/assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(item.image, fit: BoxFit.cover),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: 1000.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80.r),
                  gradient: appGradient,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    maxLines: 3,
                    item.description,
                    style: TextStyle(
                      color: theme().colorScheme.onPrimary,
                      fontSize: 70.sp,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
