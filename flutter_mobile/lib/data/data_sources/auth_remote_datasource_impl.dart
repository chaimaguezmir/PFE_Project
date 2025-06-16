import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/data/data_sources/auth_remote_datasource.dart';
import 'package:flutter_mobile/data/model/auth/activate_account/activate_account_request_model.dart';
import 'package:flutter_mobile/data/model/auth/activate_account/resend_activation_model.dart';
import 'package:flutter_mobile/data/model/auth/forgot_password/check_reset_code_result_model.dart';
import 'package:flutter_mobile/data/model/auth/forgot_password/forgot_password_result_model.dart';
import 'package:flutter_mobile/data/model/auth/login/login_request_model.dart';
import 'package:flutter_mobile/data/model/auth/login/login_result_model.dart';
import 'package:flutter_mobile/data/model/auth/signup/sign_up_request_model.dart';
import 'package:flutter_mobile/data/model/auth/signup/sign_up_result_model.dart';

/// Implementation of [AuthRemoteDataSource] using Dio HTTP client
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  /// Common headers for all requests
  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  @override
  Future<SignUpResultModel> signUp(SignUpRequestModel request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.signUp,
        data: jsonEncode(request.toJson()),
        options: Options(headers: _headers),
      );

      if (response.statusCode == 200) {
        return SignUpResultModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to sign up: ${response.statusMessage}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.signUp),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<SignUpResultModel> activateAccount(
    ActivateAccountRequestModel request,
  ) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.activateAccount,
        data: jsonEncode(request.toJson()),
        options: Options(headers: _headers),
      );

      if (response.statusCode == 200) {
        return SignUpResultModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to activate account: ${response.statusMessage}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.activateAccount),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<ResendActivationModel> resendActivation(String email) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.resendOTP,
        data: jsonEncode({'email': email}),
        options: Options(headers: _headers),
      );

      if (response.statusCode == 200) {
        return ResendActivationModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to resend activation code',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.resendOTP),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<LoginResultModel> signIn(LoginRequestModel request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.signIn,
        data: jsonEncode(request.toJson()),
        options: Options(headers: _headers),
      );

      print('Login response: ${response.data}'); // Add this line

      if (response.statusCode == 200) {
        return LoginResultModel.fromJson(response.data);
      } else {
        print('Login failed: ${response.data}'); // Add this line
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to sign in: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException: ${e.response?.data}'); // Add this line
      rethrow;
    } catch (e) {
      print('Unexpected error: $e'); // Add this line
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.signIn),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<ForgotPasswordResultModel> forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.forgotPassword,
        data: jsonEncode({'email': email}),
        options: Options(headers: _headers),
      );

      if (response.statusCode == 200) {
        return ForgotPasswordResultModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to send password reset email',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.forgotPassword),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<CheckResetCodeResultModel> checkResetCode(
    String email,
    String code,
  ) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.checkResetCode,
        data: jsonEncode({'email': email, 'code': code}),
        options: Options(headers: _headers),
      );

      if (response.statusCode == 200) {
        return CheckResetCodeResultModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Invalid reset code',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.checkResetCode),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<ForgotPasswordResultModel> resetPassword(
    String email,
    String code,
    String newPassword,
  ) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.resetPassword,
        data: jsonEncode({
          'email': email,
          'code': code,
          'newPassword': newPassword,
        }),
        options: Options(headers: _headers),
      );

      if (response.statusCode == 200) {
        return ForgotPasswordResultModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to reset password',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.resetPassword),
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
