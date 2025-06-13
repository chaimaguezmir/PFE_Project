import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/auth/activate_account_credentials.dart';
import 'package:flutter_mobile/domain/entities/auth/check_reset_code_result_entity.dart';
import 'package:flutter_mobile/domain/entities/auth/forgot_password_result_entity.dart';
import 'package:flutter_mobile/domain/entities/auth/login_credentials.dart';
import 'package:flutter_mobile/domain/entities/auth/login_result_entity.dart';
import 'package:flutter_mobile/domain/entities/auth/resend_activation_entity.dart';
import 'package:flutter_mobile/domain/entities/auth/sign_up_credentials.dart';

import '../entities/auth/sign_up_result_entity.dart';

abstract class AuthRepository {
  Future<DataState<SignUpResultEntity>> signUp(SignUpCredentials credentials);

  Future<DataState<SignUpResultEntity>> activateAccount(
    ActivateAccountCredentials credentials,
  );

  Future<DataState<ResendActivationEntity>> resendActivation(String email);

  Future<DataState<LoginResultEntity>> login(LoginCredentials credentials);

  Future<DataState<ForgotPasswordResultEntity>> forgotPassword(String email);

  Future<DataState<CheckResetCodeResultEntity>> checkResetCode(
    String email,
    String otp,
  );

  Future<DataState<ForgotPasswordResultEntity>> resetPassword(
    String email,
    String otp,
    String newPassword,
  );
}
