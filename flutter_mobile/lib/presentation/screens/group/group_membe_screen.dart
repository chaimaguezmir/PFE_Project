import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/domain/entities/group/member_entity.dart';
import 'package:flutter_mobile/injection_container.dart';
import 'package:flutter_mobile/presentation/bloc/group/group_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_app_bar.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/snackbar_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupMembersScreen extends StatelessWidget {
  const GroupMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch members when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupCubit>().fetchGroupMembers();
    });
    return BlocListener<GroupCubit, GroupState>(
      listener: (context, state) {
        // Handle error messages
        if (state.hasError) {
          SnackBarHelper.showError(context, state.errorMessage!);
        }

        // Handle success messages
        if (state.hasSuccess) {
          SnackBarHelper.showSuccess(context, state.successMessage!);
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: "Groupes", showLeading: true),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 20.h,
            ),
            width: double.infinity,
            child: const _GroupMemberBody(),
          ),
        ),
      ),
    );
  }
}

class _GroupMemberBody extends StatelessWidget {
  const _GroupMemberBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _GroupNameComponent(),
        SizedBox(height: 20.h),
        const _MembersList(),
      ],
    );
  }
}

class _GroupNameComponent extends StatelessWidget {
  const _GroupNameComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.read<GroupCubit>().state.currentGroupName,
          style: TextStyle(
            fontSize: 20.sp,
            color: theme().colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const _CustomGroupPopUpMenuButton(),
      ],
    );
  }
}

class _MembersList extends StatelessWidget {
  const _MembersList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, state) {
        if (state.status.isInProgress) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status.isFailure) {
          return Center(child: Text(state.errorMessage ?? 'Error'));
        }
        if (state.members.length == 1) {
          return const Center(child: Text('No members found.'));
        }
        return Expanded(
          child: ListView.builder(
            itemCount: state.members.length,
            itemBuilder: (context, index) {
              final MemberEntity member = state.members[index];
              // Check if the member's role is MANAGER and the current user's role is also MANAGER
              if (member.role.toUpperCase() == 'MANAGER' &&
                  state.currentGroupUserRole.toUpperCase() == 'MANAGER') {
                // Skip rendering for MANAGER role
                return const SizedBox.shrink();
              } else {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: theme().colorScheme.tertiary,
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.all(10.w),
                      ),
                      child: _MemberItem(
                        memberId: member.userId,
                        imagePath: member.profileImageUrl,
                        memberName: member.username,
                        memberRole: member.role,
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }
}

class _MemberItem extends StatelessWidget {
  const _MemberItem({
    required this.memberId,
    required this.imagePath,
    required this.memberName,
    required this.memberRole,
  });

  final String memberId;
  final String? imagePath;
  final String memberName;
  final String memberRole;

  ImageProvider _getImageProvider() {
    final defaultImage = 'lib/config/assets/images/default_avatar.jpg';

    if (imagePath != null && imagePath!.isNotEmpty) {
      if (imagePath!.startsWith('http') || imagePath!.startsWith('/uploads')) {
        // Network image (full or relative URL)
        final cleanUrl = ApiEndpoints.getImageUrl(imagePath!);
        return NetworkImage(cleanUrl);
      } else {
        // Local asset path
        return AssetImage(imagePath!);
      }
    } else {
      // Default avatar
      return AssetImage(defaultImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50.sp,
          height: 50.sp,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: _getImageProvider(),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              onError: (exception, stackTrace) {
                // Fallback to default image on error
                print('Error loading image: $exception');
              },
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                memberName,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: theme().colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                memberRole,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme().colorScheme.onPrimary.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        if (context.read<GroupCubit>().state.currentGroupUserRole ==
            'MANAGER' ||
            context.read<GroupCubit>().state.currentGroupUserRole ==
                'RESPONSIBLE' &&
                memberRole == 'MEMBER')
          _CustomPopUpMenuButtonForMembers(
            memberId: memberId,
            role: memberRole,
            memberUsername: memberName,
            memberImageUrl: imagePath,
          ),
      ],
    );
  }
}

class _CustomPopUpMenuButtonForMembers extends StatelessWidget {
  const _CustomPopUpMenuButtonForMembers({
    required this.memberId,
    required this.role,
    required this.memberUsername,
    this.memberImageUrl,
  });
  final String memberUsername;
  final String memberId;
  final String role;
  final String? memberImageUrl;

  void _handleMenuAction(BuildContext context, String value, GroupState state) {
    final cubit = context.read<GroupCubit>();
    switch (value) {
      case 'Assign':
      case 'toggle':
        cubit.selectedMemberRoleChanged(role);
        cubit.selectedMemberUsernameChanged(memberUsername);
        cubit.selectedMemberIdChanged(memberId);
        cubit.toggleRole(context);
        break;
      case 'delete':
        cubit.selectedMemberRoleChanged(role);
        cubit.selectedMemberUsernameChanged(memberUsername);
        cubit.selectedMemberIdChanged(memberId);
        cubit.removeMember(context);
      case 'manage':
        cubit.selectedMemberIdChanged(memberId);
        cubit.selectedMemberUsernameChanged(memberUsername);
        cubit.selectedMemberImageUrlChanged(memberImageUrl ?? '');
        context.pushNamed(AppRouteName.userManagementWelcome);
        break;
    }
  }

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required String iconPath,
    required String text,
  }) {
    return PopupMenuItem(
      value: value,
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 24.w,
              height: 24.h,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                text,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: theme().colorScheme.onPrimary.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, state) {
        return PopupMenuButton<String>(
          icon: const Icon(Icons.more_horiz),
          offset: const Offset(0, 50),
          onSelected: (value) => _handleMenuAction(context, value, state),
          itemBuilder: (context) => [
            if (role == 'RESPONSIBLE') ...[
              _buildMenuItem(
                value: 'delete',
                iconPath: 'lib/config/assets/icons/DeleteMember.png',
                text: 'Supprimer un membre',
              ),
              _buildMenuItem(
                value: 'toggle',
                iconPath: 'lib/config/assets/icons/CrownMinus.png',
                text: 'Désassigner un responsable',
              ),
              _buildMenuItem(
                value: 'manage',
                iconPath: 'lib/config/assets/icons/CrownMinus.png',
                text: 'Suivi et gestion d’un traitement',
              ),
            ],
            if (role == 'MEMBER') ...[
              _buildMenuItem(
                value: 'delete',
                iconPath: 'lib/config/assets/icons/DeleteMember.png',
                text: 'Supprimer un membre',
              ),
              _buildMenuItem(
                value: 'toggle',
                iconPath: 'lib/config/assets/icons/CrownMinus.png',
                text: 'Assigner un responsable',
              ),
              _buildMenuItem(
                value: 'manage',
                iconPath: 'lib/config/assets/icons/CrownMinus.png',
                text: 'Suivi et gestion d’un traitement',
              ),
            ],
          ],
        );
      },
    );
  }
}

class _CustomGroupPopUpMenuButton extends StatelessWidget {
  const _CustomGroupPopUpMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      buildWhen: (previous, current) =>
      previous.isIconSelected != current.isIconSelected,
      builder: (context, state) {
        return PopupMenuButton<String>(
          icon: state.isIconSelected
              ? ColorFiltered(
            colorFilter: ColorFilter.mode(
              theme().colorScheme.secondary,
              BlendMode.srcIn,
            ),
            child: Image.asset(
              'lib/config/assets/icons/UserCircleGear.png',
              width: 24.w,
              height: 24.w,
            ),
          )
              : ColorFiltered(
            colorFilter: ColorFilter.mode(
              theme().colorScheme.onTertiary,
              BlendMode.srcIn,
            ),
            child: Image.asset(
              'lib/config/assets/icons/UserCircleGear.png',
              width: 24.w,
              height: 24.w,
            ),
          ),
          onOpened: () {
            context.read<GroupCubit>().toggleIconSelected();
          },
          offset: const Offset(0, 50),
          onCanceled: () {
            context.read<GroupCubit>().toggleIconSelected();
          },
          onSelected: (value) async {
            context.read<GroupCubit>().toggleIconSelected();
            // Handle action
            if (value == 'add') {
              // Navigate to add member screen and wait for it to pop
              await context.pushNamed(AppRouteName.addMemberScreen);
              // Refresh members when returning
              context.read<GroupCubit>().fetchGroupMembers();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'add',
              child: Padding(
                padding: EdgeInsets.all(12.0.sp),
                child: Row(
                  children: [
                    Image.asset(
                      'lib/config/assets/icons/addUsers.png',
                      width: 24.w,
                      height: 24.h,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'Ajouter un membre',
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: theme().colorScheme.onPrimary.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}