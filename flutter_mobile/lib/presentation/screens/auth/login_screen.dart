import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/presentation/bloc/login/login_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_loading_button.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/loading_overlay.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/snackbar_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
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
        body: SafeArea(
          child: BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              return LoadingOverlay(
                isLoading: state.isLoading,
                message: 'Connexion en cours...',
                child: Container(
                  padding: EdgeInsets.only(
                    top: 150.w,
                    left: 100.h,
                    right: 100.w,
                  ),
                  child: const SingleChildScrollView(child: _LoginForm()),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _TitleWidget(),
        SizedBox(height: 80.h),

        // Error Display Section
        BlocBuilder<LoginCubit, LoginState>(
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
                        context.read<LoginCubit>().clearError();
                      },
                      icon: Icon(Icons.close, color: Colors.red, size: 45.w),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),

        const _InputFieldsSection(),
        SizedBox(height: 30.h),
        const _ForgotPasswordLink(),
        SizedBox(height: 80.h),
        const _LoginButton(),

        SizedBox(height: 60.h),
        const _SignUpLink(),
        SizedBox(height: 100.h),
        const _CustomDivider(),
        SizedBox(height: 100.h),
        _SocialLoginButton(
          label: "Se connecter avec Facebook",
          icon: Image.asset(
            'lib/config/assets/icons/facebook.png',
            height: 70.h,
            width: 70.w,
          ),
          backgroundColor: Colors.white,
          textColor: Colors.black,
          onPressed: () {
            // Handle Google login
          },
        ),

        SizedBox(height: 70.h),

        _SocialLoginButton(
          label: "Se connecter avec Google",
          icon: Image.asset(
            'lib/config/assets/icons/google.png',
            height: 70.h,
            width: 70.w,
          ),
          backgroundColor: Colors.white,
          textColor: Colors.black,
          onPressed: () {
            // Handle Facebook login
          },
        ),
      ],
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, 0),
      child: Text(
        'Se Connecter',
        style: TextStyle(
          fontSize: 60.sp,
          fontWeight: FontWeight.bold,
          color: theme().colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class _InputFieldsSection extends StatelessWidget {
  const _InputFieldsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _EmailField(),
        SizedBox(height: 50.h),
        const _PasswordField(),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.email != current.email ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        return TextField(
          style: TextStyle(color: theme().colorScheme.onPrimary),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            context.read<LoginCubit>().emailChanged(value);
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email_outlined,
              color: theme().colorScheme.onTertiary,
            ),
            labelText: 'Entrez votre E-mail',
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                width: 2.0,
                color: theme().colorScheme.tertiary, // default border color
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                color: theme().colorScheme.primary, // border color when typing
                width: 2.0,
              ),
            ),

            filled: true,
            fillColor: Colors.grey.shade50,
            errorText: state.hasError && state.email.isEmpty
                ? 'E-mail requis'
                : null,
          ),
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.isPasswordVisible != current.isPasswordVisible ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        return TextField(
          style: TextStyle(color: theme().colorScheme.onPrimary),
          obscureText: !state.isPasswordVisible,
          onChanged: (value) {
            context.read<LoginCubit>().passwordChanged(value);
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              color: theme().colorScheme.onTertiary,
            ),
            labelText: 'Entrez votre mot de passe',
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                width: 2.0,
                color: theme().colorScheme.tertiary,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                color: theme().colorScheme.primary,
                width: 2.0,
              ),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            errorText: state.hasError && state.password.isEmpty
                ? 'Mot de passe requis'
                : null,
            suffixIcon: IconButton(
              icon: Icon(
                state.isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: theme().colorScheme.onTertiary,
              ),
              onPressed: () {
                context.read<LoginCubit>().togglePasswordVisibility();
              },
            ),
          ),
        );
      },
    );
  }
}

class _ForgotPasswordLink extends StatelessWidget {
  const _ForgotPasswordLink();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) {
        return Container(
          alignment: const Alignment(1, 0),
          child: GestureDetector(
            onTap: state.isLoading
                ? null
                : () {
                    _showForgotPasswordDialog(context);
                  },
            child: Text(
              'Mot de passe oublié ?',
              style: TextStyle(
                color: theme().colorScheme.secondary,
                fontSize: 40.sp,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Mot de passe oublié', style: TextStyle(fontSize: 50.sp)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Un e-mail de réinitialisation sera envoyé à votre adresse e-mail.',
              style: TextStyle(fontSize: 40.sp),
            ),
            SizedBox(height: 40.h),
            BlocBuilder<LoginCubit, LoginState>(
              buildWhen: (previous, current) =>
                  previous.isLoading != current.isLoading,
              builder: (context, state) {
                return CustomLoadingButton(
                  isLoading: state.isLoading,
                  loadingText: "Envoi...",
                  onPressed: () {
                    context.read<LoginCubit>().forgotPassword(context);
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(
                    'Envoyer',
                    style: TextStyle(
                      fontSize: 40.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Annuler',
              style: TextStyle(
                fontSize: 40.sp,
                color: theme().colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) {
        return CustomLoadingButton(
          isLoading: state.isLoading,
          loadingText: "Connexion...",
          onPressed: state.isLoading
              ? null
              : () {
                  context.read<LoginCubit>().signInWithCredentials(context);
                },
          child: Text(
            'Se Connecter',
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

class _SignUpLink extends StatelessWidget {
  const _SignUpLink();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Vous n'avez pas de compte ? ",
          style: TextStyle(
            fontSize: 40.sp,
            color: theme().colorScheme.onTertiary,
          ),
        ),
        RichText(
          text: TextSpan(
            text: "S'inscrire",
            style: TextStyle(
              fontSize: 40.sp,
              color: theme().colorScheme.secondary,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                context.goNamed(AppRouteName.signUp);
              },
          ),
        ),
      ],
    );
  }
}

class _CustomDivider extends StatelessWidget {
  const _CustomDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 2.0)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'OU',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 38.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 2.0)),
      ],
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  });
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130.h,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.r),
            side: BorderSide(color: theme().colorScheme.tertiary, width: 4.w),
          ),

          elevation: 1,
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            SizedBox(width: 10.w),
            icon,
            SizedBox(width: 50.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 42.sp,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
