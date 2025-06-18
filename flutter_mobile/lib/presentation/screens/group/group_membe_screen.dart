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
  const GroupMembersScreen({super.key, required this.selectedGroupId});

  final String selectedGroupId;

  @override
  Widget build(BuildContext context) {
    final String token = sl<SharedPreferences>().getString('token') ?? '';
    context.read<GroupCubit>().selectedGroupIdChanged(selectedGroupId);
    // 👈 This will now work because it's the same GroupCubit instance

    // Fetch members when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupCubit>().fetchGroupMembers(token, selectedGroupId);
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Group Family',
                      style: TextStyle(
                        fontSize: 47.sp,
                        color: theme().colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const _CustomPopUpMenuButton(),
                  ],
                ),
                SizedBox(height: 40.h),

                BlocBuilder<GroupCubit, GroupState>(
                  builder: (context, state) {
                    if (state.status.isInProgress) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.status.isFailure) {
                      return Center(child: Text(state.errorMessage ?? 'Error'));
                    }
                    if (state.members.isEmpty) {
                      return const Center(child: Text('No members found.'));
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.members.length,
                        itemBuilder: (context, index) {
                          final MemberEntity member = state.members[index];
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

                                child: _CustomListMember(
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
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomListMember extends StatelessWidget {
  const _CustomListMember({
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
         _CustomPopUpMenuButtonForMembers(memberId: memberId,),
      ],
    );
  }
}

class _CustomPopUpMenuButtonForMembers extends StatelessWidget {
  const _CustomPopUpMenuButtonForMembers({required this.memberId});
  final String memberId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, state) {
        return PopupMenuButton<String>(
          icon: const Icon(Icons.more_horiz),
          onOpened: () {},
          offset: const Offset(0, 50),
          onCanceled: () {},
          onSelected: (value) {
            // Handle action
            if (value == 'Assign') {
              // Handle edit action
              context.read<GroupCubit>().toggleRole(sl<SharedPreferences>().getString('token')!, state.selectedGroupId,memberId );
            }
            else if (value == 'Unassign') {
              // Handle edit action
              context.read<GroupCubit>().toggleRole(sl<SharedPreferences>().getString('token')!, state.selectedGroupId,memberId );
            } else {
              // Handle edit action
              context.read<GroupCubit>().removeMember(sl<SharedPreferences>().getString('token')!, state.selectedGroupId,memberId );
            }

          },
          itemBuilder: (context) =>
          [
            PopupMenuItem(
              value: 'delete',

              // set your desired width
              child: Padding(
                padding: EdgeInsets.all(20.0.sp),
                child: Row(
                  children: [
                    Image.asset(
                      'lib/config/assets/icons/DeleteMember.png',
                      width: 70.w,
                      height: 70.h,
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Text(
                        'Supprimer un membre',
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
            PopupMenuItem(
              value: 'Assign',

              // set your desired width
              child: Padding(
                padding: EdgeInsets.all(20.0.sp),
                child: Row(
                  children: [
                    Image.asset(
                      'lib/config/assets/icons/CrownMinus.png',
                      width: 70.w,
                      height: 70.h,
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Text(
                        'Assigner un responsable',
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
            PopupMenuItem(
              value: 'Unassign',

              // set your desired width
              child: Padding(
                padding: EdgeInsets.all(20.0.sp),
                child: Row(
                  children: [
                    Image.asset(
                      'lib/config/assets/icons/CrownMinus.png',
                      width: 70.w,
                      height: 70.h,
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Text(
                        'Désassigner un responsable',
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

class _CustomPopUpMenuButton extends StatelessWidget {
  const _CustomPopUpMenuButton({super.key});

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
          itemBuilder: (context) =>
          [
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
