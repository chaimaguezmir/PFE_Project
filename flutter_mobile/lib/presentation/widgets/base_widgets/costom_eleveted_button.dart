import 'package:flutter/material.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.height,
    this.width,
    this.backgroundColor,
    this.isLoading = false,
    this.icon,
    this.enabled = true,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final bool isLoading;
  final Widget? icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? theme().colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
        ),
        onPressed: (enabled && !isLoading) ? onPressed : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, SizedBox(width: 20.w)],
            child,
            if (isLoading) ...[
              SizedBox(width: 20.w),
              SizedBox(
                width: 10.w,
                height: 10.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
