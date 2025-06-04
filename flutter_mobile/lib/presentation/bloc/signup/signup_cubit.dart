import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/sign_up_result_entity.dart';
import 'package:flutter_mobile/domain/repositories/auth_repository.dart';
import 'package:formz/formz.dart';

import '../../../domain/entities/sign_up_credentials.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authRepository) : super(const SignUpState());

  final AuthRepository _authRepository;

  void usernameChanged(String value) {
    emit(state.copyWith(username: value));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value));
  }

  void phoneNumberChanged(String value) {
    emit(state.copyWith(phoneNumber: value));
  }
  void birthdateChanged(String value) {
    emit(state.copyWith(birthdate: value));
  }

  void genderChanged(Gender value){
    emit(state.copyWith(gender: value));
  }

  void confirmPasswordChanged(String value) {
    emit(state.copyWith(confirmPassword: value));
  }

  void otpCodeChanged(int value) {
    emit(state.copyWith(otpCode: value));
  }

  void termsAcceptedChanged(bool value) {
    emit(state.copyWith(isTermsAccepted: value));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> signUpWithCredentials(BuildContext context) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final result = await _authRepository.signUp(
      SignUpCredentials(
        username: state.username,
        email: state.email,
        password: state.password,
      ),
    );

    if (result is DataSuccess) {
      emit(state.copyWith(status: FormzSubmissionStatus.success));
      print('Sign up successful: ${result.data}');
    } else {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      SignUpResultEntity(message: result.error!);
      print('Sign up failed: ${result.error}');
    }
  }
}
