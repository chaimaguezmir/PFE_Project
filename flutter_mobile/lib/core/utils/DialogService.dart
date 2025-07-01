import 'package:flutter/material.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

mixin DialogService {
  static Future<void> showRemoveMemberDialog({
    required BuildContext context,
    required String avatarPath,
    required String message,
    required String groupName,
    required VoidCallback onConfirm,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        contentPadding: EdgeInsets.all(20.w), // Added explicit padding
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 0.8.sw, // Limit dialog width to 80% of screen
            maxHeight: 0.7.sh, // Limit dialog height to 70% of screen
          ),
          child: SingleChildScrollView(
            // Prevent overflow on small screens
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16.h), // Reduced from 50.h
                Container(
                  width: 50.w, // Reduced from 150.w
                  height: 50.w, // Reduced from 150.w
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(avatarPath),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
                SizedBox(height: 20.h), // Reduced from 80.h
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp, // Reduced from 45.sp
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 12.h), // Reduced from 50.h
                Text(
                  groupName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp, // Reduced from 38.sp
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 30.h), // Reduced from 70.h
                // Wrap buttons in flexible layout to prevent overflow
                Wrap(
                  spacing: 12.w,
                  runSpacing: 12.h,
                  alignment: WrapAlignment.center,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade500),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      onPressed: () {
                        context.pop();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Annuler',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(width: 8.w), // Reduced from 15.w
                          Icon(
                            Icons.cancel,
                            color: Colors.grey.shade500,
                            size: 18.sp,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme().colorScheme.secondary,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context, rootNavigator: true).pop();
                        onConfirm();
                      },
                      child: Text(
                        'Confirmer',
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> showSuccessDialog({
    required BuildContext context,
    required String userName,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        contentPadding: EdgeInsets.all(20.w),
        content: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 0.8.sw, maxHeight: 0.6.sh),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                  size: 48.sp, // Reduced from 60
                ),
                SizedBox(height: 16.h), // Reduced from 20
                Text(
                  '$userName a été retiré du groupe avec succès.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp, // Reduced from 18
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16.h), // Added bottom spacing
                TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: theme().colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
