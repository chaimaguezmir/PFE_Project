import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SimpleCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SimpleCustomAppBar({
    super.key,
    required this.title,
    this.onBack,
  });

  final String title;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => Size.fromHeight(55.h);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.colorScheme.onSecondary,
      foregroundColor: theme.colorScheme.onSecondary,
      shadowColor: theme.colorScheme.onSecondary,
      surfaceTintColor: theme.colorScheme.onSecondary,
      centerTitle: true,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 55.h,
      leading: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: ElevatedButton(
          onPressed: onBack ?? () => context.pop(),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            backgroundColor: theme.colorScheme.onSecondary,
            padding: EdgeInsets.zero,
            elevation: 4,
          ),
          child: Icon(
            Icons.arrow_back,
            color: theme.colorScheme.onPrimary,
            size: 18.sp,
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}