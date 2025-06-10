import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/auth/login_credentials.dart';

import 'package:flutter_mobile/domain/repositories/auth_repository.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';


part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(const LoginState());

  final AuthRepository _authRepository;

  void emailChanged(String value) {
    emit(state.copyWith(
      email: value,
      errorMessage: null,
    ));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(
      password: value,
      errorMessage: null,
    ));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void rememberMeChanged(bool value) {
    emit(state.copyWith(rememberMe: value));
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
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

    if (state.password.isEmpty) {
      emit(state.copyWith(errorMessage: 'Le mot de passe est requis'));
      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> signInWithCredentials(BuildContext context) async {
    emit(state.copyWith(errorMessage: null));

    if (!_isFormValid()) {
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final result = await _authRepository.login(
        LoginCredentials(
          email: state.email.trim(),
          password: state.password,
        ),
      );

      if (result is DataSuccess) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          successMessage: 'Connexion réussie!',
        ));
        if (context.mounted) {
           context.goNamed(AppRouteName.home);
        }
      } else {
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: result.error ?? 'Identifiants incorrects',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Erreur de connexion. Veuillez vérifier votre connexion internet.',
      ));
    }
  }

  Future<void> forgotPassword(BuildContext context) async {
    if (state.email.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Veuillez entrer votre adresse e-mail'));
      return;
    }

    if (!_isValidEmail(state.email)) {
      emit(state.copyWith(errorMessage: 'Adresse e-mail invalide'));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      // TODO: Implement forgot password API call
      await Future.delayed(const Duration(seconds: 1));

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        successMessage: 'Instructions de réinitialisation envoyées à votre e-mail',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Erreur lors de l\'envoi de l\'e-mail de réinitialisation',
      ));
    }
  }

  Future<void> retryLogin(BuildContext context) async {
    await signInWithCredentials(context);
  }
}
