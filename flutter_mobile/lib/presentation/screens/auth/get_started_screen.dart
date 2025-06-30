import 'package:flutter/material.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 100.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100.h),
              Image.asset(
                'lib/config/assets/images/logo.png',
                // Update with your logo path
                height: 600.h,
              ),
              SizedBox(height: 100.h),
              Text(
                "C’est parti !",
                style: TextStyle(
                  fontSize: 70.sp,
                  fontWeight: FontWeight.bold,
                  color: theme().colorScheme.onPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              Text(
                "Organisez vos traitements, retrouvez votre \n équilibre",
                style: TextStyle(
                  fontSize: 45.sp,
                  color: theme().colorScheme.onTertiary,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 120.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 100.0.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme().colorScheme.primary,
                      padding: EdgeInsets.symmetric(vertical: 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                    ),
                    onPressed: () {
                      context.goNamed(AppRouteName.signIn);
                    },
                    child: Text(
                      "Se connecter",
                      style: TextStyle(
                        fontSize: 45.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 100.0.w),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: theme().colorScheme.secondary,
                        width: 3.w,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                    ),
                    onPressed: () {
                      context.goNamed(AppRouteName.signUp);
                    },
                    child: Text(
                      "S'inscrire",
                      style: TextStyle(
                        fontSize: 45.sp,
                        color: theme().colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}