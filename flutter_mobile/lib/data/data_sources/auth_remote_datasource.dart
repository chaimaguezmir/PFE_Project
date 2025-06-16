import 'package:flutter_mobile/data/model/auth/activate_account/activate_account_request_model.dart';
import 'package:flutter_mobile/data/model/auth/activate_account/resend_activation_model.dart';
import 'package:flutter_mobile/data/model/auth/forgot_password/check_reset_code_result_model.dart';
import 'package:flutter_mobile/data/model/auth/forgot_password/forgot_password_result_model.dart';
import 'package:flutter_mobile/data/model/auth/login/login_request_model.dart';
import 'package:flutter_mobile/data/model/auth/login/login_result_model.dart';
import 'package:flutter_mobile/data/model/auth/signup/sign_up_request_model.dart';
import 'package:flutter_mobile/data/model/auth/signup/sign_up_result_model.dart';

/// Abstract interface for authentication remote data source operations
abstract class AuthRemoteDataSource {
  Future<SignUpResultModel> signUp(SignUpRequestModel request);

  Future<SignUpResultModel> activateAccount(
    ActivateAccountRequestModel request,
  );

  Future<ResendActivationModel> resendActivation(String email);

  Future<LoginResultModel> signIn(LoginRequestModel request);

  Future<ForgotPasswordResultModel> forgotPassword(String email);

  Future<CheckResetCodeResultModel> checkResetCode(String email, String code);

  Future<ForgotPasswordResultModel> resetPassword(
    String email,
    String code,
    String newPassword,
  );
}
