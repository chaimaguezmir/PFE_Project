import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBar({
    super.key,
    required this.title,
    required this.username,
    required this.email,
    required this.avatarPath,
    this.onBack,
    this.showLeading = true, // Default: show leading button
  });
  final String title;
  final String username;
  final String email;
  final String avatarPath;
  final VoidCallback? onBack;
  final bool showLeading;

  @override
  Size get preferredSize => Size.fromHeight(300.h);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: AppBar(
        backgroundColor: theme.colorScheme.onSecondary,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 150.h,
        leading: showLeading
            ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: onBack ?? () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              backgroundColor: theme.colorScheme.onSecondary,
              padding: EdgeInsets.zero,
              elevation: 4,
            ),
            child: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary),
          ),
        )
            : null,
        title: Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 45.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
            child: Row(

              children: [
                SizedBox(width: 20.w),
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(avatarPath),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter, // 👈 Focus on the top of the image
                    ),
                  ),
                ),
                SizedBox(width: 30.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimary.withOpacity(0.7),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}