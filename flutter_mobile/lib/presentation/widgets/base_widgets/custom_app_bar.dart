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
    this.showLeading = true,
  });

  final String title;
  final String username;
  final String email;
  final String avatarPath;
  final VoidCallback? onBack;
  final bool showLeading;

  @override
  Size get preferredSize => Size.fromHeight(150.h); // Reduced from 350.h

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
      leading: showLeading
          ? Padding(
        padding:  EdgeInsets.all(8.0.w), // Reduced padding
        child: ElevatedButton(
          onPressed: onBack ?? () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r), // Slightly smaller radius
            ),
            backgroundColor: theme.colorScheme.onSecondary,
            padding: EdgeInsets.zero,
            elevation: 4,
          ),
          child: Icon(
            Icons.arrow_back,
            color: theme.colorScheme.onPrimary,
            size: 18.sp, // Added explicit size
          ),
        ),
      )
          : null,
      title: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: 20.sp, // Reduced from 45.sp
          fontWeight: FontWeight.w500,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60.h), // Adjusted to fit content
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
          child: Row(
            children: [
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
              SizedBox(width: 16.w), // Reduced spacing
              Expanded( // Added Expanded to prevent overflow
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      username,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp, // Added explicit size
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h), // Added spacing between texts
                    Text(
                      email,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimary.withOpacity(0.7),
                        fontSize: 14.sp, // Added explicit size
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}