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
      backgroundColor: theme().colorScheme.onSecondary,
      appBar: const CustomAppBar(title: "Ajouter Un Membre", showLeading: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 24.w),
          child: const Column(
            children: [
              _QRCodeSection(),
              _ScanningSection(),
              _QRCodeButton(),
              _EmailSection(),
              _AddMemberButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _QRCodeSection extends StatelessWidget {
  const _QRCodeSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(
              'lib/config/assets/icons/ScanQrCode.png',
              width: 40.w,
              height: 40.h,
            ),
            SizedBox(width: 16.w),
            Text(
              'Scanner un QR code',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          'Autorisez la caméra pour scanner le QR code du membre.',
          style: TextStyle(
            fontSize: 14.sp,
            color: theme().colorScheme.onPrimary.withOpacity(0.5),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _ScanningSection extends StatelessWidget {
  const _ScanningSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 32.h),
        Image.asset(
          'lib/config/assets/images/Scanning.png',
          width: 100.w,
          height: 100.h,
        ),
        SizedBox(height: 20.h),
        Text(
          'Scanning Code...',
          style: TextStyle(
            fontSize: 16.sp,
            color: theme().colorScheme.onPrimary.withOpacity(0.4),
          ),
        ),
        SizedBox(height: 16.h),
        Image.asset(
          'lib/config/assets/icons/stackScanningIcons.png',
          width: 80.w,
        ),
        SizedBox(height: 40.h),
      ],
    );
  }
}

class _QRCodeButton extends StatelessWidget {
  const _QRCodeButton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0.w),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: theme().colorScheme.secondary,
                  width: 2.w,
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
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
                    "Scanner QR Code",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: theme().colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    Icons.qr_code_scanner,
                    color: theme().colorScheme.secondary,
                    size: 20.w,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 32.h),
      ],
    );
  }
}

class _EmailSection extends StatelessWidget {
  const _EmailSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Identifiant utilisateur',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 12.h),
        const _EmailField(),
        SizedBox(height: 32.h),
      ],
    );
  }
}

class _AddMemberButton extends StatelessWidget {
  const _AddMemberButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0.w),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme().colorScheme.secondary,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.r),
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
                  fontSize: 16.sp,
                  color: theme().colorScheme.onSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 12.w),
              Icon(
                Icons.add_circle_outline,
                color: theme().colorScheme.onSecondary,
                size: 20.w,
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
              borderRadius: BorderRadius.all(
                Radius.circular(25.r),
              ), // Reduced from 100.r
              borderSide: BorderSide(
                width: 2.0,
                color: theme().colorScheme.tertiary,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25.r),
              ), // Reduced from 100.r
              borderSide: BorderSide(
                color: theme().colorScheme.primary,
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
