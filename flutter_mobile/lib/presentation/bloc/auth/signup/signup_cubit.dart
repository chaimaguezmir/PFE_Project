import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/auth/activate_account_credentials.dart';
import 'package:flutter_mobile/domain/entities/auth/sign_up_credentials.dart';
import 'package:flutter_mobile/domain/repositories/auth_repository.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';



part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authRepository) : super(const SignUpState());

  final AuthRepository _authRepository;

  void usernameChanged(String value) {
    emit(
      state.copyWith(
        username: value,
        errorMessage: null, // Clear error when user starts typing
      ),
    );
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, errorMessage: null));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, errorMessage: null));
  }

  void phoneNumberChanged(String value) {
    emit(state.copyWith(phoneNumber: value, errorMessage: null));
  }

  void birthdateChanged(String value) {
    emit(state.copyWith(birthdate: value, errorMessage: null));
  }

  void genderChanged(Gender value) {
    emit(state.copyWith(gender: value, errorMessage: null));
  }

  void confirmPasswordChanged(String value) {
    emit(state.copyWith(confirmPassword: value, errorMessage: null));
  }

  // Call this in otpCodeChanged:
  void otpCodeChanged(String value) {
    emit(
      state.copyWith(
        otpCode: value,
        isButtonEnabled:
            value.length == 6 && RegExp(r'^\d{6}$').hasMatch(value),
        errorMessage: null,
      ),
    );
  }

  void termsAcceptedChanged(bool value) {
    emit(state.copyWith(isTermsAccepted: value, errorMessage: null));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  // Form validation
  bool _isFormValid() {
    if (state.username.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Le nom d\'utilisateur est requis'));
      return false;
    }

    if (state.email.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'L\'adresse e-mail est requise'));
      return false;
    }

    if (!_isValidEmail(state.email)) {
      emit(state.copyWith(errorMessage: 'Adresse e-mail invalide'));
      return false;
    }

    if (state.password.isEmpty) {
      emit(state.copyWith(errorMessage: 'Le mot de passe est requis'));
      return false;
    }

    if (state.password.length < 6) {
      emit(
        state.copyWith(
          errorMessage: 'Le mot de passe doit contenir au moins 6 caractères',
        ),
      );
      return false;
    }

    if (state.phoneNumber.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Le numéro de téléphone est requis'));
      return false;
    }

    if (state.birthdate.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'La date de naissance est requise'));
      return false;
    }

    if (state.gender == Gender.none) {
      emit(state.copyWith(errorMessage: 'Veuillez sélectionner votre genre'));
      return false;
    }

    if (!state.isTermsAccepted) {
      emit(
        state.copyWith(
          errorMessage: 'Vous devez accepter les conditions d\'utilisation',
        ),
      );
      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Method to retry signup in case of failure

  Future<void> signUpWithCredentials(BuildContext context) async {
    // Clear any existing errors
    emit(state.copyWith(errorMessage: null));

    // Validate form
    if (!_isFormValid()) {
      return;
    }

    // Set loading state
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final result = await _authRepository.signUp(
        SignUpCredentials(
          username: state.username.trim(),
          email: state.email.trim(),
          password: state.password,
        ),
      );

      if (result is DataSuccess) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            successMessage: result.data?.message ?? 'Inscription réussie!',
          ),
        );

        if (context.mounted) {
          context.goNamed(AppRouteName.accountVerification);
        }
      } else {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage:
                result.error ??
                'Une erreur est survenue lors de l\'inscription',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage:
              'Erreur de connexion. Veuillez vérifier votre connexion internet.',
        ),
      );
    }
  }

  Future<void> activateAccount(BuildContext context) async {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        errorMessage: null,
      ),
    );

    final result = await _authRepository.activateAccount(
      ActivateAccountCredentials(email: state.email, code: state.otpCode),
    );

    if (result is DataSuccess) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
          successMessage: result.data?.message ?? 'Account activated!',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: result.error ?? 'Activation failed',
        ),
      );
    }
    // If activation is successful, navigate to the home screen
    if (context.mounted) {
      context.goNamed(AppRouteName.signIn);
    }
  }

  Future<void> resendOtpCode(BuildContext context) async {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        errorMessage: null,
        successMessage: null,
      ),
    );

    final result = await _authRepository.resendActivation(state.email);

    if (result is DataSuccess) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
          successMessage:
              result.data?.message ?? 'Le code a été renvoyé avec succès.',
        ),
      );
      startResendTimer();
    } else {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: result.error ?? 'Échec de l\'envoi du code.',
        ),
      );
    }
  }

  Timer? _timer;

  void startResendTimer() {
    _timer?.cancel();
    emit(state.copyWith(otpResendCounter: 29));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.otpResendCounter! <= 1) {
        timer.cancel();
        emit(state.copyWith(otpResendCounter: 0));
      } else {
        emit(state.copyWith(otpResendCounter: state.otpResendCounter! - 1));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
