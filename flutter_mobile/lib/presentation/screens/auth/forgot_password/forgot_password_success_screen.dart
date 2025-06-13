import 'package:flutter/material.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_loading_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordSuccessScreen extends StatelessWidget {
  const ForgotPasswordSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 80.w, right: 80.w, top: 300.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('lib/config/assets/images/successmark.png'),
              SizedBox(height: 50.h),
              Text(
                'Opération réussie',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 60.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 130.h),
              Text(
                'Votre mot de passe a été modifié \navec succès.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45.sp,
                  fontWeight: FontWeight.w400,
                  color: theme().colorScheme.onTertiary,
                ),
              ),
              SizedBox(height: 70.h),
              CustomLoadingButton(
                loadingText: "Inscription...",
                onPressed: () {
                  context.goNamed(AppRouteName.signIn);
                },
                child: Text(
                  "Retour à la connexion",
                  style: TextStyle(
                    fontSize: 45.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
