import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
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
        appBar: const CustomAppBar(
          title: "Groupes",
          username: "Walid Zaroui",
          email: "zarwi.walid@gmail.com",
          avatarPath: "lib/config/assets/images/default_avatar.jpg",
          showLeading: true,
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 70.w, right: 70.w, top: 50.w),
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
        SizedBox(height: 40.h),

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
            fontSize: 47.sp,
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
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: theme().colorScheme.tertiary,
                            width: 2.w,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.all(30.0.w),
                      ),

                      child: _MemberItem(
                        memberId: member.userId,
                        imagePath:
                            'lib/config/assets/images/default_avatar.jpg',
                        memberName: member.username,
                        memberRole: member.role,
                      ),
                    ),
                    SizedBox(height: 30.h),
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
  final String imagePath;
  final String memberName;
  final String memberRole;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        SizedBox(width: 30.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                memberName,
                style: TextStyle(
                  fontSize: 45.sp,
                  color: theme().colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                memberRole,
                style: TextStyle(
                  fontSize: 30.sp,
                  color: theme().colorScheme.onPrimary.withOpacity(0.8),
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
  });
  final String memberUsername;
  final String memberId;
  final String role;

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
        padding: EdgeInsets.all(20.0.sp),
        child: Row(
          children: [
            Image.asset(iconPath, width: 70.w, height: 70.h),
            SizedBox(width: 20.w),
            Expanded(
              child: Text(
                text,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 35.sp,
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
                    'lib/config/assets/icons/UserCircleGear.png', // your asset path
                    width: 60.w,
                    height: 60.w,
                  ),
                )
              : ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    theme().colorScheme.onTertiary,
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(
                    'lib/config/assets/icons/UserCircleGear.png', // your asset path
                    width: 60.w,
                    height: 60.w,
                  ),
                ),
          onOpened: () {
            context.read<GroupCubit>().toggleIconSelected();
          },
          offset: const Offset(0, 50),
          onCanceled: () {
            context.read<GroupCubit>().toggleIconSelected();
          },
          onSelected: (value) {
            context.read<GroupCubit>().toggleIconSelected();
            // Handle action
            if (value == 'add') {
              // Handle edit action
              context.pushNamed(AppRouteName.addMemberScreen);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'add',

              // set your desired width
              child: Padding(
                padding: EdgeInsets.all(20.0.sp),
                child: Row(
                  children: [
                    Image.asset(
                      'lib/config/assets/icons/addUsers.png',
                      width: 70.w,
                      height: 70.h,
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Text(
                        'Ajouter un membre',
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 35.sp,
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
