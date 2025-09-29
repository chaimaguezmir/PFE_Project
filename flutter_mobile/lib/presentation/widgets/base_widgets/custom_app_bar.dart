import 'package:flutter/material.dart';
import 'package:flutter_mobile/core/utils/shared_prefs_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.showLeading = true,
  });

  final String title;
  final VoidCallback? onBack;
  final bool showLeading;

  @override
  Size get preferredSize => Size.fromHeight(150.h);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  late SharedPrefsUtils _prefsUtils;
  String _displayName = 'User';
  String _email = '';
  String _avatarPath = 'lib/config/assets/images/default_avatar.jpg';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _prefsUtils = SharedPrefsUtils();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final profile = await _prefsUtils.getUserProfile();
      setState(() {
        _displayName = _prefsUtils.getDisplayName();
        _email = profile['email'] as String? ?? '';
        _avatarPath = _prefsUtils.getAvatarPath();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

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
      leading: widget.showLeading
          ? Padding(
        padding: EdgeInsets.all(8.0.w),
        child: ElevatedButton(
          onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
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
      )
          : null,
      title: Text(
        widget.title,
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: _isLoading
            ? Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25.w,
                backgroundColor: Colors.grey[300],
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 100.w,
                      height: 16.h,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      width: 150.w,
                      height: 14.h,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
            : Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
          child: Row(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(_avatarPath),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _displayName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _email,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimary.withOpacity(0.7),
                        fontSize: 14.sp,
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