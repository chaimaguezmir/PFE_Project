import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/presentation/bloc/auth/forgot_password/forgot_password_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_loading_button.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/loading_overlay.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/snackbar_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordEmailScreen extends StatelessWidget {
  const ForgotPasswordEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
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
        appBar: AppBar(
          backgroundColor: theme().colorScheme.onSecondary,
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 48.w,
              height: 48.w,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  elevation: 4,
                  backgroundColor: theme().colorScheme.onSecondary,
                  padding: EdgeInsets.zero,
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.arrow_back,
                  color: theme().colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
            builder: (context, state) {
              return LoadingOverlay(
                isLoading: state.isLoading,
                message: 'Envoi du lien de réinitialisation...',
                child: Container(
                  padding: EdgeInsets.only(
                    top: 150.w,
                    left: 100.h,
                    right: 100.w,
                  ),

                  child: const SingleChildScrollView(
                    child: _ForgotPasswordForm(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ForgotPasswordForm extends StatelessWidget {
  const _ForgotPasswordForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Entrez votre  E-mail',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20.h),
        const _ErrorDisplaySection(),
        SizedBox(height: 80.h),
        const Text(
          'Vous recevrez un lien de confirmation du changement de mot de passe à l\'adresse E-mail fournie',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        SizedBox(height: 80.h),
        const _EmailTextField(),
        SizedBox(height: 100.h),
        const _CustomLoadingElevatedButton(),

        // Here you can add the email input field and submit button
      ],
    );
  }
}

class _EmailTextField extends StatelessWidget {
  const _EmailTextField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (previous, current) =>
          previous.email != current.email ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        return TextField(
          onChanged: (value) {
            context.read<ForgotPasswordCubit>().emailChanged(value);
          },
          style: const TextStyle(color: Colors.black),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email_outlined),
            labelText: 'Entrez votre adresse E-mail',
            floatingLabelStyle: TextStyle(color: theme().colorScheme.primary),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(75.r)),
              borderSide: BorderSide(color: theme().colorScheme.tertiary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(75.r),
              borderSide: BorderSide(
                color: theme().colorScheme.tertiary,
                width: 2,
              ),
            ),
            focusColor: theme().colorScheme.primary,
            filled: true,
            fillColor: Colors.white,
            errorText: state.hasError && state.email.isEmpty
                ? 'E-mail requis'
                : null,
          ),
        );
      },
    );
  }
}

class _CustomLoadingElevatedButton extends StatelessWidget {
  const _CustomLoadingElevatedButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) {
        return CustomLoadingButton(
          isLoading: state.isLoading,
          loadingText: "Envoi en cours...",
          onPressed: state.isLoading
              ? null
              : () {
                  context.read<ForgotPasswordCubit>().sendOTP(context);
                },
          child: Text(
            "Confirmer votre adresse e-mail",
            style: TextStyle(
              fontSize: 45.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}

class _ErrorDisplaySection extends StatelessWidget {
  const _ErrorDisplaySection();

  @override
  Widget build(BuildContext context) {
    return // Error Display Section
    BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        if (state.hasError) {
          return Container(
            margin: EdgeInsets.only(bottom: 40.h),
            padding: EdgeInsets.all(30.w),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 50.w),
                SizedBox(width: 20.w),
                Expanded(
                  child: Text(
                    state.errorMessage!,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 38.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<ForgotPasswordCubit>().clearError();
                  },
                  icon: Icon(Icons.close, color: Colors.red, size: 45.w),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
