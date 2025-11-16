import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/presentation/bloc/auth/auth/auth_bloc.dart';
import 'package:flutter_mobile/presentation/bloc/group/group_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// App bar showing both current user (manager) and managed user
/// Used in user management screens to show who is managing whom
class DualUserAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DualUserAppBar({
    super.key,
    required this.title,
    this.showLeading = true,
  });

  final String title;
  final bool showLeading;

  @override
  Size get preferredSize => Size.fromHeight(55.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: showLeading
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 20.sp,
                color: Colors.black87,
              ),
              onPressed: () => context.pop(),
            )
          : null,
      title: Row(
        children: [
          // Current user (manager) avatar - reactive to profile image changes
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              return _buildUserAvatar(
                imageUrl: authState.profileImageUrl ?? 'lib/config/assets/images/default_avatar.jpg',
                isCurrentUser: true,
              );
            },
          ),
          SizedBox(width: 8.w),

          // Arrow indicating management direction
          Icon(
            Icons.arrow_forward,
            size: 16.sp,
            color: Colors.grey[600],
          ),
          SizedBox(width: 8.w),

          // Managed user avatar and info
          Expanded(
            child: BlocBuilder<GroupCubit, GroupState>(
              builder: (context, state) {
                return Row(
                  children: [
                    _buildUserAvatar(
                      imageUrl: state.selectedMemberImageUrl,
                      isCurrentUser: false,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (state.selectedMemberUsername.isNotEmpty)
                            Text(
                              state.selectedMemberUsername,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar({
    required String imageUrl,
    required bool isCurrentUser,
  }) {
    final size = isCurrentUser ? 32.w : 36.w;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isCurrentUser ? Colors.grey[300]! : Colors.blue[400]!,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: size / 2 - 2,
        backgroundImage: _getImageProvider(imageUrl),
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.isEmpty || imageUrl == 'lib/config/assets/images/default_avatar.jpg') {
      return const AssetImage('lib/config/assets/images/default_avatar.jpg');
    }

    if (imageUrl.startsWith('http') || imageUrl.startsWith('/uploads')) {
      final cleanUrl = ApiEndpoints.getImageUrl(imageUrl);
      return NetworkImage(cleanUrl);
    }

    return AssetImage(imageUrl);
  }
}
