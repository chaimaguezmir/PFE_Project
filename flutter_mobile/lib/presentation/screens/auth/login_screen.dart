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
                  padding: EdgeInsets.symmetric(
                    horizontal: 50.w,
                    vertical: 100.h,
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
        SizedBox(height: 40.h),
        const _RememberMeSection(),
        SizedBox(height: 60.h),
        const _LoginButton(),
        SizedBox(height: 40.h),
        const _ForgotPasswordLink(),
        SizedBox(height: 60.h),
        const _SignUpLink(),
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
          color: theme().colorScheme.secondary,
        ),
      ),
    );
  }
}

class _InputFieldsSection extends StatelessWidget {
  const _InputFieldsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 80.h),
      width: 850.w,
      child: Column(
        children: [
          const _EmailField(),
          SizedBox(height: 50.h),
          const _PasswordField(),
        ],
      ),
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
          style: const TextStyle(color: Colors.black),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            context.read<LoginCubit>().emailChanged(value);
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email_outlined, color: Colors.black),
            labelText: 'Entrez votre E-mail',
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.black),
            ),
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
          style: const TextStyle(color: Colors.black),
          obscureText: !state.isPasswordVisible,
          onChanged: (value) {
            context.read<LoginCubit>().passwordChanged(value);
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: Colors.black,
            ),
            labelText: 'Mot de passe',
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.black),
            ),
            filled: true,
            fillColor: Colors.white,
            errorText: state.hasError && state.password.isEmpty
                ? 'Mot de passe requis'
                : null,
            suffixIcon: IconButton(
              icon: Icon(
                state.isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
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

class _RememberMeSection extends StatelessWidget {
  const _RememberMeSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.rememberMe != current.rememberMe,
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              value: state.rememberMe,
              onChanged: (value) {
                context.read<LoginCubit>().rememberMeChanged(value ?? false);
              },
              activeColor: theme().colorScheme.secondary,
            ),
            Text(
              'Se souvenir de moi',
              style: TextStyle(
                fontSize: 40.sp,
                color: theme().colorScheme.onSurface,
              ),
            ),
          ],
        );
      },
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
                color: theme().colorScheme.primary,
                fontSize: 40.sp,
                decoration: TextDecoration.underline,
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
            fontSize: 38.sp,
            color: theme().colorScheme.onTertiary,
          ),
        ),
        RichText(
          text: TextSpan(
            text: "S'inscrire",
            style: TextStyle(
              fontSize: 38.sp,
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
