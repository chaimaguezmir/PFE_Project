import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/presentation/bloc/auth/forgot_password/forgot_password_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_loading_button.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/loading_overlay.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/snackbar_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordNewPasswordScreen extends StatelessWidget {
  const ForgotPasswordNewPasswordScreen({super.key});

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
            padding:  EdgeInsets.all(8.0.w),
            child: SizedBox(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  elevation: 4,
                  backgroundColor: theme().colorScheme.onSecondary,
                  padding: EdgeInsets.zero,
                ),
                onPressed: () =>context.pop(),
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
                    top: 50.h,
                    left: 20.w,
                    right: 20.w,
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
         Text(
          'Créer un nouveau mot de passe',
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20.h),
        const _ErrorDisplaySection(),
        SizedBox(height: 10.h),
         Text(
          'Votre nouveau mot de passe doit être différent de ceux que vous avez déjà utilisés',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
        SizedBox(height: 50.h),
        const _PasswordField(),
        SizedBox(height: 15.h),
        const _PasswordConfirmationField(),
        SizedBox(height: 50.h),
        const _CustomLoadingElevatedButton(),

        // Here you can add the email input field and submit button
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (previous, current) =>
          previous.isPasswordVisible != current.isPasswordVisible ||
          previous.password != current.password,
      builder: (context, state) {
        return TextField(
          onChanged: (value) {
            context.read<ForgotPasswordCubit>().passwordChanged(value);
          },
          style: const TextStyle(color: Colors.black),
          obscureText: !state.isPasswordVisible,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            labelText: 'Nouveau mot de passe',
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
            errorText: state.hasError && state.password.isEmpty
                ? 'Mot de passe requis'
                : null,
            suffixIcon: IconButton(
              icon: Icon(
                color: theme().colorScheme.onTertiary,
                state.isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () {
                context.read<ForgotPasswordCubit>().togglePasswordVisibility();
              },
            ),
          ),
        );
      },
    );
  }
}

class _PasswordConfirmationField extends StatelessWidget {
  const _PasswordConfirmationField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (previous, current) =>
          previous.isPasswordVisible != current.isPasswordVisible ||
          previous.confirmPassword != current.confirmPassword,
      builder: (context, state) {
        return TextField(
          onChanged: (value) {
            context.read<ForgotPasswordCubit>().confirmPasswordChanged(value);
          },
          style: const TextStyle(color: Colors.black),
          obscureText: !state.isPasswordVisible,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            labelText: 'Confirmer  mot de passe',
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
            errorText: state.hasError && state.confirmPassword.isEmpty
                ? 'Mot de passe requis'
                : null,
            suffixIcon: IconButton(
              icon: Icon(
                color: theme().colorScheme.onTertiary,
                state.isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () {
                context.read<ForgotPasswordCubit>().togglePasswordVisibility();
              },
            ),
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
                  context.read<ForgotPasswordCubit>().submit(context);
                },
          child: Text(
            "Confirmer",
            style: TextStyle(
              fontSize: 18.sp,
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
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (previous, current) =>
      previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        if (state.hasError) {
          return Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 20.sp),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    state.errorMessage!,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<ForgotPasswordCubit>().clearError();
                  },
                  icon: Icon(Icons.close, color: Colors.red, size: 20.sp),
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
