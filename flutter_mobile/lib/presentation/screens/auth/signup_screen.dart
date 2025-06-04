import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/presentation/bloc/signup/signup_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme/theme_data_config.dart';
import '../../../injection_container.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 150.h, left: 50.w, right: 50.w),
          child: SingleChildScrollView(
            child: BlocProvider(
              create: (context) => sl<SignUpCubit>(),
              child: const _SignUpInterface(),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignUpInterface extends StatelessWidget {
  const _SignUpInterface();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _TitleWidget(),

        const _SubtitleWidget(),

        _InputFields(),
        SizedBox(height: 40.h),

        //WidgetFor Gender Selection
        const _GenderSelection(),

        //WidgetFor Terms and Conditions
        const _TermsAndConditions(),
        SizedBox(height: 70.h),
        //WidgetFor Sign Up Button
        SizedBox(
          width: double.infinity,
          height: 130.h,
          child: const _CustomElevatedButton(),
        ),
        SizedBox(height: 50.h),
        //WidgetFor Bottom text with link
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
          // Phone Input
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
      child: BlocBuilder<SignUpCubit, SignUpState>(
        builder: (context, state) {
          return Text(state.isTermsAccepted.toString());
        },
      ),

      // child: Text(
      //   'Inscrivez-vous pour commencer.',
      //   style: TextStyle(fontSize: 45.sp, color: Colors.grey.shade600),
      // ),
    );
  }
}

class _BottomTextWithLink extends StatelessWidget {
  const _BottomTextWithLink({super.key});

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
              decoration: TextDecoration.none,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // TODO: Handle navigation to sign up
                context.go('/login');
              },
          ),
        ),
      ],
    );
  }
}

class _UsernameField extends StatelessWidget {
  const _UsernameField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.black),
      onChanged: (value) {
        context.read<SignUpCubit>().usernameChanged(value);
      },
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person_outline),
        labelText: 'Entrez votre Nom / Prénom',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

class _EmailTextField extends StatelessWidget {
  const _EmailTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        context.read<SignUpCubit>().emailChanged(value);
      },
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.email_outlined),
        labelText: 'Entrez votre adresse E-mail',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.isPasswordVisible != current.isPasswordVisible,
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
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(color: Colors.black),
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: Icon(
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
    return TextField(
      onChanged: (value) {
        context.read<SignUpCubit>().phoneNumberChanged(value);
      },

      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.phone,

      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.phone_outlined),
        labelText: 'Votre Télephone',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

class _BirthdateField extends StatelessWidget {
  const _BirthdateField(this.controller, this.onTap);
  final TextEditingController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.black),
      controller: controller,
      readOnly: true,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.calendar_month),
        labelText: 'Date de naissance',
        filled: true,
        fillColor: Colors.white,
      ),
      onTap: onTap,
    );
  }
}

class _GenderSelection extends StatelessWidget {
  const _GenderSelection();

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Gender?> selectedGender = ValueNotifier<Gender?>(null);
    return Column(
      children: [
        Container(
          alignment: const Alignment(-1, 0),
          child: Text(
            'Genre',
            style: TextStyle(
              color: theme().colorScheme.onTertiary,
              fontSize: 45.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40).w,
          child: BlocBuilder<SignUpCubit, SignUpState>(
            buildWhen: (previous, current) => previous.gender != current.gender,
            builder: (context, state) {
              return Row(
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
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TermsAndConditions extends StatelessWidget {
  const _TermsAndConditions();

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> acceptedTerms = ValueNotifier<bool>(false);
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.isTermsAccepted != current.isTermsAccepted,
  builder: (context, state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: state.isTermsAccepted,
          activeColor: Colors.grey.shade200,
          checkColor: theme().colorScheme.secondary,
          side: BorderSide(color: theme().colorScheme.onTertiary, width: 3.w),
          onChanged: (checked) => context.read<SignUpCubit>().termsAcceptedChanged(checked!),
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
    );
  },
);
  }
}

class _CustomElevatedButton extends StatelessWidget {
  const _CustomElevatedButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme().colorScheme.primary,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      onPressed: () {
        // TODO: Implement sign up action
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
  }
}


