import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/repositories/auth_repository.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._authRepository)
    : super(const ForgotPasswordState());

  final AuthRepository _authRepository;

  void emailChanged(String value) {
    emit(state.copyWith(email: value, errorMessage: null));
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        isButtonEnabled: value.isNotEmpty && value.length >= 6,
        errorMessage: null,
      ),
    );
  }

  void confirmPasswordChanged(String value) {
    emit(
      state.copyWith(
        confirmPassword: value,
        isButtonEnabled: value.isNotEmpty && value == state.password,
        errorMessage: null,
      ),
    );
  }

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

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isFormValid() {
    if (state.email.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'L\'adresse e-mail est requise'));
      return false;
    }

    if (!_isValidEmail(state.email)) {
      emit(state.copyWith(errorMessage: 'Adresse e-mail invalide'));
      return false;
    }

    return true;
  }

  Future<void> checkResetCode(BuildContext context) async {
    emit(state.copyWith(errorMessage: null));

    if (state.otpCode.isEmpty || state.otpCode.length != 6) {
      emit(
        state.copyWith(errorMessage: 'Le code de réinitialisation est requis'),
      );
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final result = await _authRepository.checkResetCode(
        state.email.trim(),
        state.otpCode.trim(),
      );

      if (result is DataSuccess && result.data != null) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            successMessage: result.data!.message,
          ),
        );
        if (context.mounted) {
          context.pushReplacementNamed(
            AppRouteName.forgotPasswordNewPasswordScreen,
          );
        }
      } else {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage:
                result.error ?? "Erreur lors de la vérification du code.",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage:
              "Erreur lors de la vérification du code. Veuillez vérifier votre connexion internet.",
        ),
      );
    }
  }

  Future<void> sendOTP(BuildContext context) async {
    emit(state.copyWith(errorMessage: null));

    if (!_isFormValid()) {
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final result = await _authRepository.forgotPassword(state.email.trim());

      if (result is DataSuccess && result.data != null) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            successMessage: result.data!.message,
          ),
        );
        if (context.mounted) {
          context.pushReplacementNamed(AppRouteName.forgotPasswordCodeScreen);
        }
      } else {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: result.error ?? "Erreur lors de l'envoi de l'e-mail.",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage:
              "Erreur lors de l'envoi de l'e-mail. Veuillez vérifier votre connexion internet.",
        ),
      );
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
    startResendTimer();

    final result = await _authRepository.forgotPassword(state.email);

    if (result is DataSuccess) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
          successMessage:
              result.data?.message ?? 'Le code a été renvoyé avec succès.',
        ),
      );
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
      if (state.otpResendCounter <= 1) {
        timer.cancel();
        emit(state.copyWith(otpResendCounter: 0));
      } else {
        emit(state.copyWith(otpResendCounter: state.otpResendCounter - 1));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> submit(BuildContext context) async {
    emit(state.copyWith(errorMessage: null));

    if (state.password.isEmpty) {
      emit(state.copyWith(errorMessage: 'Le mot de passe est requis'));
      return;
    }
    if (state.confirmPassword.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'La confirmation du mot de passe est requise',
        ),
      );
      return;
    }

    if (state.password != state.confirmPassword) {
      emit(
        state.copyWith(errorMessage: 'Les mots de passe ne correspondent pas'),
      );
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final result = await _authRepository.resetPassword(
        state.email.trim(),
        state.otpCode.trim(),
        state.password.trim(),
      );

      if (result is DataSuccess && result.data != null) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            successMessage: result.data!.message,
          ),
        );
        if (context.mounted) {
          context.goNamed(AppRouteName.forgotPasswordSuccessScreen);
        }
      } else {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage:
                result.error ??
                "Erreur lors de la réinitialisation du mot de passe.",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage:
              "Erreur lors de la réinitialisation du mot de passe. Veuillez vérifier votre connexion internet.",
        ),
      );
    }
  }
}
