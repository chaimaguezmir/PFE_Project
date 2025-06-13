import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/presentation/bloc/signup/signup_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_loading_button.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/loading_overlay.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/snackbar_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme/theme_data_config.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
        body: SafeArea(
          child: BlocBuilder<SignUpCubit, SignUpState>(
            builder: (context, state) {
              return LoadingOverlay(
                isLoading: state.isLoading,
                message: 'Création de votre compte...',
                child: Container(
                  padding: EdgeInsets.only(top: 150.h, left: 50.w, right: 50.w),
                  child: const SingleChildScrollView(child: _SignUpForm()),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SignUpForm extends StatelessWidget {
  const _SignUpForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _TitleWidget(),
        const _SubtitleWidget(),
        const _ErrorDisplaySection(),
        _InputFields(),
        SizedBox(height: 40.h),
        const _GenderSelection(),
        const _TermsAndConditions(),
        SizedBox(height: 70.h),
        const _CustomLoadingElevatedButton(),
        SizedBox(height: 50.h),
        const _BottomTextWithLink(),
      ],
    );
  }
}

class _InputFields extends StatelessWidget {
  _InputFields();

  final TextEditingController birthdateController = TextEditingController();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      birthdateController.text = "${picked.day}/${picked.month}/${picked.year}";
      if (context.mounted) {
        context.read<SignUpCubit>().birthdateChanged(birthdateController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        children: [
          const _UsernameField(),
          SizedBox(height: 50.h),
          const _EmailTextField(),
          SizedBox(height: 50.h),
          const _PasswordField(),
          SizedBox(height: 50.h),
          const _PhoneNumberTextField(),
          SizedBox(height: 50.h),
          _BirthdateField(birthdateController, () => selectDate(context)),
        ],
      ),
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
        'Créer votre compte',
        style: TextStyle(
          fontSize: 60.sp,
          fontWeight: FontWeight.bold,
          color: theme().colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class _SubtitleWidget extends StatelessWidget {
  const _SubtitleWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.h),
      alignment: const Alignment(-0.9, 0),
      child: Text(
        'Inscrivez-vous pour commencer.',
        style: TextStyle(fontSize: 45.sp, color: Colors.grey.shade600),
      ),
    );
  }
}

class _UsernameField extends StatelessWidget {
  const _UsernameField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          style: const TextStyle(color: Colors.black),
          onChanged: (value) {
            context.read<SignUpCubit>().usernameChanged(value);
          },

          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person_outline),
            labelText: 'Entrez votre Nom / Prénom',
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

            errorText: state.hasError && state.username.isEmpty
                ? 'Nom requis'
                : null,
          ),
        );
      },
    );
  }
}

class _EmailTextField extends StatelessWidget {
  const _EmailTextField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (value) {
            context.read<SignUpCubit>().emailChanged(value);
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

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.isPasswordVisible != current.isPasswordVisible ||
          previous.password != current.password,
      builder: (context, state) {
        return TextField(
          onChanged: (value) {
            context.read<SignUpCubit>().passwordChanged(value);
          },
          style: const TextStyle(color: Colors.black),
          obscureText: !state.isPasswordVisible,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            labelText: 'Entrez votre mot de passe',
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
                context.read<SignUpCubit>().togglePasswordVisibility();
              },
            ),
          ),
        );
      },
    );
  }
}

class _PhoneNumberTextField extends StatelessWidget {
  const _PhoneNumberTextField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.phoneNumber != current.phoneNumber,
      builder: (context, state) {
        return TextField(
          onChanged: (value) {
            context.read<SignUpCubit>().phoneNumberChanged(value);
          },
          style: const TextStyle(color: Colors.black),
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.phone_outlined),
            labelText: 'Votre Téléphone',
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
            errorText: state.hasError && state.phoneNumber.isEmpty
                ? 'Téléphone requis'
                : null,
          ),
        );
      },
    );
  }
}

class _BirthdateField extends StatelessWidget {
  const _BirthdateField(this.controller, this.onTap);

  final TextEditingController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.birthdate != current.birthdate,
      builder: (context, state) {
        return TextField(
          style: const TextStyle(color: Colors.black),
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.calendar_month),
            labelText: 'Date de naissance',
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
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(75.r),
              borderSide: BorderSide(
                color: theme().colorScheme.tertiary, // Set your color here
                width: 2,
              ),
            ),
            focusColor: theme().colorScheme.primary,
            filled: true,
            fillColor: Colors.white,

            errorText: state.hasError && state.birthdate.isEmpty
                ? 'Date de naissance requise'
                : null,
          ),
          onTap: onTap,
        );
      },
    );
  }
}

class _GenderSelection extends StatelessWidget {
  const _GenderSelection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.gender != current.gender ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        return Column(
          children: [
            Container(
              alignment: const Alignment(-1, 0),
              child: Text(
                'Genre',
                style: TextStyle(
                  color: state.hasError && state.gender == Gender.none
                      ? Colors.red
                      : theme().colorScheme.onTertiary,
                  fontSize: 45.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40).w,
              child: Row(
                children: [
                  Radio<Gender>(
                    value: Gender.male,
                    activeColor: theme().colorScheme.secondary,
                    groupValue: state.gender,
                    onChanged: (gender) =>
                        context.read<SignUpCubit>().genderChanged(gender!),
                  ),
                  Text(
                    'Homme',
                    style: TextStyle(
                      fontSize: 45.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 40.w),
                  Radio<Gender>(
                    value: Gender.female,
                    groupValue: state.gender,
                    activeColor: theme().colorScheme.secondary,
                    onChanged: (gender) =>
                        context.read<SignUpCubit>().genderChanged(gender!),
                  ),
                  Text(
                    'Femme',
                    style: TextStyle(
                      fontSize: 45.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            if (state.hasError && state.gender == Gender.none)
              Container(
                alignment: const Alignment(-1, 0),
                margin: EdgeInsets.only(top: 10.h),
                child: Text(
                  'Veuillez sélectionner votre genre',
                  style: TextStyle(color: Colors.red, fontSize: 35.sp),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _TermsAndConditions extends StatelessWidget {
  const _TermsAndConditions();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.isTermsAccepted != current.isTermsAccepted ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: state.isTermsAccepted,
                  activeColor: Colors.grey.shade200,
                  checkColor: theme().colorScheme.secondary,
                  side: BorderSide(
                    color: state.hasError && !state.isTermsAccepted
                        ? Colors.red
                        : theme().colorScheme.onTertiary,
                    width: 3.w,
                  ),
                  onChanged: (checked) => context
                      .read<SignUpCubit>()
                      .termsAcceptedChanged(checked!),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 40.sp,
                        color: Colors.black,
                        fontFamily: 'Roboto',
                      ),
                      children: [
                        const TextSpan(text: "J'accepte les "),
                        TextSpan(
                          text: "Conditions d'Utilisation",
                          style: TextStyle(
                            color: theme().colorScheme.secondary,
                            decoration: TextDecoration.none,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Handle Conditions d'Utilisation tap
                            },
                        ),
                        const TextSpan(text: " et "),
                        TextSpan(
                          text: "La Politique de Confidentialité",
                          style: TextStyle(
                            color: theme().colorScheme.secondary,
                            decoration: TextDecoration.none,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Handle Politique de Confidentialité tap
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (state.hasError && !state.isTermsAccepted)
              Container(
                alignment: const Alignment(-1, 0),
                margin: EdgeInsets.only(top: 10.h),
                child: Text(
                  'Vous devez accepter les conditions d\'utilisation',
                  style: TextStyle(color: Colors.red, fontSize: 35.sp),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CustomLoadingElevatedButton extends StatelessWidget {
  const _CustomLoadingElevatedButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) {
        return CustomLoadingButton(
          isLoading: state.isLoading,
          loadingText: "Inscription...",
          onPressed: state.isLoading
              ? null
              : () {
                  context.read<SignUpCubit>().signUpWithCredentials(context);
                },
          child: Text(
            "S'inscrire",
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

class _BottomTextWithLink extends StatelessWidget {
  const _BottomTextWithLink();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Vous avez déjà un compte ? ",
          style: TextStyle(
            fontSize: 38.sp,
            color: theme().colorScheme.onTertiary,
          ),
        ),
        RichText(
          text: TextSpan(
            text: "Se connecter",
            style: TextStyle(
              fontSize: 38.sp,
              color: theme().colorScheme.secondary,
              decoration: TextDecoration.none,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                context.goNamed(AppRouteName.signIn);
              },
          ),
        ),
      ],
    );
  }
}

class _ErrorDisplaySection extends StatelessWidget {
  const _ErrorDisplaySection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
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
                    context.read<SignUpCubit>().clearError();
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
