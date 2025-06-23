import 'package:flutter/material.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 50.h),
            Container(
              width: 150.w,
              height: 150.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(avatarPath),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            SizedBox(height: 80.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style:  TextStyle(fontSize: 45.sp,color: Colors.grey),

            ),
            SizedBox(height: 50.h),
            Text(
              ' $groupName',
              style:  TextStyle(fontSize: 38.sp, color: Colors.black),
            ),
            SizedBox(height: 70.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side:  BorderSide(color: Colors.grey.shade500),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child:  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Annuler',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                       SizedBox(width: 15.w),
                      Icon(Icons.cancel, color: Colors.grey.shade500),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme().colorScheme.secondary,
                  ),
                  child: const Text(
                    'Confirmer',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    onConfirm();
                  },
                ),
              ],
            ),
          ],
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.delete_forever, color: Colors.red, size: 60),
            const SizedBox(height: 20),
            Text(
              '$userName a été retiré du groupe avec succès.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
