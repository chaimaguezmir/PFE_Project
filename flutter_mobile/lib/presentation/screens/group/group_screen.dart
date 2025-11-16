import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/domain/entities/group/group_entity.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/group/group_cubit.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme().scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: "Groupes", showLeading: false),
      body: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, state) {
          if (state.status.isInProgress && state.groups.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                color: theme().colorScheme.primary,
                strokeWidth: 3,
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // Modern Header Section with Stats
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.all(20.w),
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme().colorScheme.primary,
                        theme().colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28.r),
                    boxShadow: [
                      BoxShadow(
                        color: theme().colorScheme.primary.withOpacity(0.35),
                        blurRadius: 25,
                        spreadRadius: 0,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Vos Groupes',
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: -1,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  'Gérez vos équipes efficacement',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white.withOpacity(0.85),
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(18.r),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              Icons.groups_rounded,
                              color: Colors.white,
                              size: 32.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.pie_chart_rounded,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              '${state.groups.length} groupe${state.groups.length > 1 ? 's' : ''} actif${state.groups.length > 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Groups Grid
              if (state.groups.isEmpty)
                SliverFillRemaining(child: _EmptyGroupsState())
              else
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return _GroupCard(group: state.groups[index]);
                    }, childCount: state.groups.length),
                  ),
                ),

              // Bottom Spacing
              SliverToBoxAdapter(child: SizedBox(height: 100.h)),
            ],
          );
        },
      ),
      floatingActionButton: _AddGroupButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group});

  final GroupEntity group;

  Color _getRoleColor(BuildContext context, String role) {
    switch (role.toUpperCase()) {
      case 'MANAGER':
        return theme().colorScheme.primary;
      case 'RESPONSIBLE':
        return theme().colorScheme.secondary;
      case 'MEMBER':
        return theme().colorScheme.tertiary;
      default:
        return theme().colorScheme.onSurface.withOpacity(0.5);
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role.toUpperCase()) {
      case 'MANAGER':
        return Icons.workspace_premium_rounded;
      case 'RESPONSIBLE':
        return Icons.shield_rounded;
      case 'MEMBER':
        return Icons.person_rounded;
      default:
        return Icons.group;
    }
  }

  String _getRoleText(String role) {
    switch (role.toUpperCase()) {
      case 'MANAGER':
        return 'Manager';
      case 'RESPONSIBLE':
        return 'Responsable';
      case 'MEMBER':
        return 'Membre';
      default:
        return role;
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleColor = _getRoleColor(context, group.role);

    return GestureDetector(
      onTap: () {
        context.read<GroupCubit>().currentGroupIdChanged(group.groupId);
        context.read<GroupCubit>().currentGroupUserRoleChanged(group.role);
        context.read<GroupCubit>().currentGroupNameChanged(group.name);
        context.pushNamed(AppRouteName.groupMembersScreen);
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme().cardColor,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: theme().dividerColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: roleColor.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Stack(
            children: [
              // Animated Gradient Background
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        roleColor.withOpacity(0.12),
                        roleColor.withOpacity(0.04),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),

              // Decorative Circle
              Positioned(
                top: -25.h,
                right: -25.w,
                child: Container(
                  width: 90.w,
                  height: 90.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: roleColor.withOpacity(0.08),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(18.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon with modern styling
                    Container(
                      width: 58.w,
                      height: 58.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [roleColor, roleColor.withOpacity(0.75)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18.r),
                        boxShadow: [
                          BoxShadow(
                            color: roleColor.withOpacity(0.35),
                            blurRadius: 12,
                            spreadRadius: 0,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.groups_rounded,
                        color: Colors.white,
                        size: 30.sp,
                      ),
                    ),

                    const Spacer(),

                    // Group Name
                    Text(
                      group.name,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: theme().colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 10.h),

                    // Modern Role Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 7.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            roleColor.withOpacity(0.15),
                            roleColor.withOpacity(0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: roleColor.withOpacity(0.25),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getRoleIcon(group.role),
                            size: 15.sp,
                            color: roleColor,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            _getRoleText(group.role),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: roleColor,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Modern Arrow Indicator
              Positioned(
                bottom: 18.h,
                right: 18.w,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: roleColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: roleColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 16.sp,
                    color: roleColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyGroupsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Modern illustration container
          Container(
            width: 150.w,
            height: 150.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme().colorScheme.primary.withOpacity(0.15),
                  theme().colorScheme.secondary.withOpacity(0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme().colorScheme.primary.withOpacity(0.15),
                  blurRadius: 40,
                  spreadRadius: 0,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring
                Container(
                  width: 130.w,
                  height: 130.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme().colorScheme.primary.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                ),
                Icon(
                  Icons.groups_rounded,
                  size: 72.sp,
                  color: theme().colorScheme.primary.withOpacity(0.5),
                ),
                Positioned(
                  bottom: 28.h,
                  right: 28.w,
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme().colorScheme.primary,
                          theme().colorScheme.secondary,
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme().colorScheme.primary.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 36.h),
          Text(
            'Aucun groupe',
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              color: theme().colorScheme.onSurface,
              letterSpacing: -0.8,
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: Text(
              'Créez votre premier groupe pour commencer à collaborer avec vos membres',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: theme().colorScheme.onSurface.withOpacity(0.6),
                height: 1.6,
                letterSpacing: 0.1,
              ),
            ),
          ),
          SizedBox(height: 40.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: [
                BoxShadow(
                  color: theme().colorScheme.primary.withOpacity(0.35),
                  blurRadius: 25,
                  spreadRadius: 0,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                context.pushNamed(AppRouteName.addGroupScreen);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme().colorScheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 18.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.r),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add_rounded, size: 22.sp),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Créer un groupe',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddGroupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            theme().colorScheme.primary,
            theme().colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme().colorScheme.primary.withOpacity(0.5),
            blurRadius: 25,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: theme().colorScheme.secondary.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.pushNamed(AppRouteName.addGroupScreen);
          },
          borderRadius: BorderRadius.circular(32.r),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring animation effect
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
              ),
              // Plus icon
              Icon(
                Icons.add_rounded,
                size: 32.sp,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}