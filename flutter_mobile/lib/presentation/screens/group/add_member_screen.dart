import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/injection_container.dart';
import 'package:flutter_mobile/presentation/bloc/group/group_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMemberScreen extends StatelessWidget {
  const AddMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          theme().colorScheme.onSecondary, // Match your app bar color
      appBar: const CustomAppBar(
        title: "Ajouter Un Membre",
        username: "Walid Zaroui",
        email: "zarwi.walid@gmail.com",
        avatarPath: "lib/config/assets/images/default_avatar.jpg",
        showLeading: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 50.w, right: 50.w, top: 150.w),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    'lib/config/assets/icons/ScanQrCode.png',
                    width: 100.w,
                    height: 100.h,
                  ),
                  SizedBox(width: 40.w),
                  Text(
                    'Scanner un QR code',
                    style: TextStyle(
                      fontSize: 50.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Text(
                'Autorisez la caméra pour scanner le QR code du membre.',
                style: TextStyle(
                  fontSize: 35.sp,
                  color: theme().colorScheme.onPrimary.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 100.h),
              Image.asset(
                'lib/config/assets/images/Scanning.png',
                width: 250.w,
                height: 250.h,
              ),
              SizedBox(height: 60.h),
              Text(
                'Scanning Code...',
                style: TextStyle(
                  fontSize: 30.sp,
                  color: theme().colorScheme.onPrimary.withOpacity(0.4),
                ),
              ),
              SizedBox(height: 35.h),
              Image.asset(
                'lib/config/assets/icons/stackScanningIcons.png',
                width: 250.w,
              ),
              SizedBox(height: 150.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 180.0.w),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: theme().colorScheme.secondary,
                        width: 3.w,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 30.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                    ),
                    onPressed: () {
                      // context.goNamed(AppRouteName.signUp);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Ajouter au groupe",
                          style: TextStyle(
                            fontSize: 40.sp,
                            color: theme().colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 30.w),
                        Icon(
                          Icons.add_circle_outline,
                          color: theme().colorScheme.secondary,
                          size: 60.w,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 80.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Identifiant utilisateur',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 42.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              const _EmailField(),
              SizedBox(height: 120.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 180.0.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme().colorScheme.secondary,
                      padding: EdgeInsets.symmetric(vertical: 30.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                    ),
                    onPressed: () {
                      context.read<GroupCubit>().addMember();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Ajouter au groupe",
                          style: TextStyle(
                            fontSize: 40.sp,
                            color: theme().colorScheme.onSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 30.w),
                        Icon(
                          Icons.add_circle_outline,
                          color: theme().colorScheme.onSecondary,
                          size: 60.w,
                        ),
                      ],
                    ),
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

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      buildWhen: (previous, current) =>
          previous.email != current.email ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        return TextField(
          style: TextStyle(color: theme().colorScheme.onPrimary),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            context.read<GroupCubit>().emailChanged(value);
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email_outlined,
              color: theme().colorScheme.onTertiary,
            ),
            suffixIcon: Image.asset(
              'lib/config/assets/icons/ScanQrCode24px.png',
            ),
            labelText: 'Entrez votre E-mail',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100.r)),
              borderSide: BorderSide(
                width: 2.0,
                color: theme().colorScheme.tertiary, // default border color
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100.r)),
              borderSide: BorderSide(
                color: theme().colorScheme.primary, // border color when typing
                width: 2.0,
              ),
            ),

            filled: true,
            fillColor: Colors.grey.shade50,
            errorText: state.errorMessage,
          ),
        );
      },
    );
  }
}
