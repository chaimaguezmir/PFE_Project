import 'package:flutter/material.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorDisplayWidget extends StatelessWidget {
  const ErrorDisplayWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
    this.showRetryButton = true,
  });

  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final bool showRetryButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.error_outline,
            size: 120.w,
            color: theme().colorScheme.error,
          ),
          SizedBox(height: 40.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 42.sp,
              color: theme().colorScheme.error,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (showRetryButton && onRetry != null) ...[
            SizedBox(height: 60.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme().colorScheme.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 30.h),
              ),
              child: Text(
                'Réessayer',
                style: TextStyle(
                  fontSize: 40.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
