import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/presentation/bloc/group/group_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/snackbar_helper.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/simple_custom_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class AddGroupScreen extends StatefulWidget {
  const AddGroupScreen({super.key});

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupCubit, GroupState>(
      listener: (context, state) {
        if (state.status.isSuccess && state.successMessage != null) {
          SnackBarHelper.showSuccess(context, state.successMessage!);
          context.read<GroupCubit>().clearGroupName();
          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              context.pop();
            }
          });
        }
        if (state.status.isFailure && state.errorMessage != null) {
          SnackBarHelper.showError(context, state.errorMessage!);
        }
      },
      child: Scaffold(
        backgroundColor: theme().scaffoldBackgroundColor,
        appBar: const SimpleCustomAppBar(title: 'Nouveau Groupe'),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HeaderSection(),
                    SizedBox(height: 48.h),
                    _FormSection(),
                    SizedBox(height: 40.h),
                    _CreateButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Animated Icon with pulse effect
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1000),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme().colorScheme.primary,
                      theme().colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme().colorScheme.primary.withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer ring
                    Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.group_add_rounded,
                      size: 56.sp,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: 28.h),
        Text(
          'Créer un nouveau groupe',
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            color: theme().colorScheme.onSurface,
            letterSpacing: -0.8,
          ),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Text(
            'Donnez un nom unique à votre groupe pour commencer à collaborer',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              color: theme().colorScheme.onSurface.withOpacity(0.6),
              height: 1.6,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ],
    );
  }
}

class _FormSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      buildWhen: (previous, current) =>
      previous.newGroupName != current.newGroupName ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: theme().cardColor,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: theme().dividerColor.withOpacity(0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: theme().shadowColor.withOpacity(0.08),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme().colorScheme.primary.withOpacity(0.15),
                            theme().colorScheme.primary.withOpacity(0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.badge_outlined,
                        size: 22.sp,
                        color: theme().colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nom du groupe',
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold,
                              color: theme().colorScheme.onSurface,
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Requis',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: theme().colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              Divider(
                height: 1,
                thickness: 1,
                color: theme().dividerColor.withOpacity(0.5),
              ),

              // Input Field
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                child: TextField(
                  onChanged: (value) {
                    context.read<GroupCubit>().groupNameChanged(value);
                  },
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: state.newGroupName,
                      selection: TextSelection.collapsed(
                        offset: state.newGroupName.length,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: theme().colorScheme.onSurface,
                    letterSpacing: -0.2,
                  ),
                  maxLength: 50,
                  decoration: InputDecoration(
                    hintText: 'Ex: Famille, Amis, Travail...',
                    hintStyle: TextStyle(
                      color: theme().colorScheme.onSurface.withOpacity(0.35),
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 18.h),
                    counterText: '', // Hide default counter
                    suffixIcon: state.newGroupName.isNotEmpty
                        ? Container(
                      margin: EdgeInsets.only(right: 8.w),
                      child: IconButton(
                        icon: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: theme().colorScheme.surface,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: theme().colorScheme.onSurface.withOpacity(0.5),
                            size: 18.sp,
                          ),
                        ),
                        onPressed: () {
                          context.read<GroupCubit>().clearGroupName();
                        },
                      ),
                    )
                        : null,
                  ),
                ),
              ),

              // Error and Character Counter
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (state.errorMessage != null)
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 16.sp,
                              color: theme().colorScheme.error,
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                state.errorMessage!,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: theme().colorScheme.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      const SizedBox(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme().colorScheme.surface,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '${state.newGroupName.length}/50',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: theme().colorScheme.onSurface.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CreateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      buildWhen: (previous, current) =>
      previous.status != current.status ||
          previous.isCreateGroupFormValid != current.isCreateGroupFormValid,
      builder: (context, state) {
        final isValid = state.isCreateGroupFormValid;
        final isLoading = state.status.isInProgress;

        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 400),
          tween: Tween(begin: 0.92, end: isValid ? 1.0 : 0.92),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: double.infinity,
                height: 60.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: isValid && !isLoading
                      ? [
                    BoxShadow(
                      color: theme().colorScheme.primary.withOpacity(0.5),
                      blurRadius: 25,
                      spreadRadius: 0,
                      offset: const Offset(0, 12),
                    ),
                  ]
                      : null,
                ),
                child: ElevatedButton(
                  onPressed: isValid && !isLoading
                      ? () => context.read<GroupCubit>().createGroup()
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isValid
                        ? theme().colorScheme.primary
                        : theme().disabledColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: theme().disabledColor,
                  ),
                  child: isLoading
                      ? SizedBox(
                    width: 26.w,
                    height: 26.w,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Créer le groupe',
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
            );
          },
        );
      },
    );
  }
}