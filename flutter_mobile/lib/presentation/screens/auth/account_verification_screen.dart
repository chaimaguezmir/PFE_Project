import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/presentation/bloc/auth/signup/signup_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/costom_eleveted_button.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/snackbar_helper.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountVerificationScreen extends StatelessWidget {
  const AccountVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
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
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 50.w, left: 20.h, right: 20.w),
            child: const _AccountVerificationForm(),
          ),
        ),
      ),
    );
  }
}

class _AccountVerificationForm extends StatelessWidget {
  const _AccountVerificationForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'OTP Verification',
          style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 50.h),
        Text(
          textAlign: TextAlign.center,
          'Entrez le code de vérification que nous venons d\'envoyer à votre adresse e-mail',
          style: TextStyle(fontSize: 18.sp, color: Colors.grey[600]),
        ),
        SizedBox(height: 40.h),
        const _OtpWithResend(),

        SizedBox(height: 50.h),
        BlocBuilder<SignUpCubit, SignUpState>(
          buildWhen: (previous, current) =>
              previous.isButtonEnabled != current.isButtonEnabled,
          builder: (context, state) {
            return CustomElevatedButton(
              enabled: state.isButtonEnabled,
              onPressed: () {
                context.read<SignUpCubit>().activateAccount(context);
              },
              child: Text(
                'Envoyer',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: theme().colorScheme.onSecondary,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _OtpWithResend extends StatelessWidget {
  const _OtpWithResend();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enter Otp Code',
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
                color: theme().colorScheme.onTertiary,
              ),
            ),
            BlocBuilder<SignUpCubit, SignUpState>(
              buildWhen: (previous, current) =>
                  previous.otpResendCounter != current.otpResendCounter,
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    if (state.otpResendCounter == 0) {
                      context.read<SignUpCubit>().resendOtpCode(context);
                    }
                  },
                  child: Text(
                    state.otpResendCounter == 0
                        ? 'Resend'
                        : 'Resend in 00:${state.otpResendCounter.toString().padLeft(2, '0')}  ',

                    style: TextStyle(
                      fontSize: 17.sp,
                      color: state.otpResendCounter == 0
                          ? theme().colorScheme.secondary
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 20.h),
        const _CustomOtpTextField(),
      ],
    );
  }
}

class _CustomOtpTextField extends StatelessWidget {
  const _CustomOtpTextField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.otpCode != current.otpCode,
      builder: (context, state) {
        return OtpTextField(
          fieldWidth: 50.w,
          enabledBorderColor: theme().colorScheme.onTertiary,
          focusedBorderColor: theme().colorScheme.secondary,

          numberOfFields: 6,
          borderColor: const Color(0xFF512DA8),
          //set to true to show as box or false to show as dash
          showFieldAsBox: true,

          //runs when a code is typed in
          onCodeChanged: (String code) {
            context.read<SignUpCubit>().otpCodeChanged(code);
          },
          onSubmit: (String verificationCode) {
            context.read<SignUpCubit>().otpCodeChanged(verificationCode);
          }, // end onSubmit
        );
      },
    );
  }
}
