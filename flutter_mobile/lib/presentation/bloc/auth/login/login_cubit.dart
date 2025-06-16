import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/core/utils/device_utils.dart';
import 'package:flutter_mobile/core/utils/shared_prefs_utils.dart';
import 'package:flutter_mobile/data/model/auth/login/login_result_model.dart';
import 'package:flutter_mobile/domain/entities/auth/login_credentials.dart';
import 'package:flutter_mobile/domain/repositories/auth_repository.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(const LoginState());

  final AuthRepository _authRepository;

  void emailChanged(String value) {
    emit(state.copyWith(email: value, errorMessage: null));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, errorMessage: null));
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
      final deviceInfo = await getDeviceInfo();
      final result = await _authRepository.login(
        LoginCredentials(
          email: state.email.trim(),
          password: state.password,
          deviceId: deviceInfo['deviceId'] ?? '',
          deviceName: deviceInfo['deviceName'] ?? '',
        ),
      );

      if (result is DataSuccess) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            successMessage: 'Connexion réussie!',
          ),
        );
        final model = LoginResultModel.fromEntity(result.data!);
        await saveLoginResult(model);
        if (context.mounted) {
          context.goNamed(AppRouteName.mainScreen);
        }
      } else {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: result.error ?? 'Identifiants incorrects',
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

  Future<void> retryLogin(BuildContext context) async {
    await signInWithCredentials(context);
  }
}
