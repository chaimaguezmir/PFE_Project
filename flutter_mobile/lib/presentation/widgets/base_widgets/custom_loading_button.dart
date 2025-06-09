import 'package:flutter/material.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLoadingButton extends StatelessWidget {
  const CustomLoadingButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.height,
    this.width,
    this.backgroundColor,
    this.enabled = true,
    this.loadingText,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final bool enabled;
  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 130.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? theme().colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: (enabled && !isLoading) ? onPressed : null,
        child: isLoading
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50.w,
              height: 50.w,
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
            if (loadingText != null) ...[
              SizedBox(width: 30.w),
              Text(
                loadingText!,
                style: TextStyle(
                  fontSize: 45.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        )
            : child,
      ),
    );
  }
}