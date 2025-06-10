import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/data/model/auth/activate_account/activate_account_request_model.dart';
import 'package:flutter_mobile/data/model/auth/activate_account/resend_activation_model.dart';
import 'package:flutter_mobile/data/model/auth/login/login_request_model.dart';
import 'package:flutter_mobile/data/model/auth/login/login_result_model.dart';
import 'package:flutter_mobile/domain/entities/auth/activate_account_credentials.dart';
import 'package:flutter_mobile/domain/entities/auth/login_credentials.dart';
import 'package:flutter_mobile/domain/entities/auth/login_result_entity.dart';
import 'package:flutter_mobile/domain/entities/auth/resend_activation_entity.dart';
import 'package:flutter_mobile/domain/entities/auth/sign_up_credentials.dart';
import 'package:flutter_mobile/domain/entities/auth/sign_up_result_entity.dart';
import 'package:flutter_mobile/domain/repositories/auth_repository.dart';
import 'package:flutter_mobile/data/model/auth/signup/sign_up_request_model.dart';
import 'package:flutter_mobile/data/model/auth/signup/sign_up_result_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio);
  final Dio _dio;

  @override
  Future<DataState<SignUpResultEntity>> signUp(
    SignUpCredentials credentials,
  ) async {
    try {
      final requestModel = SignUpRequestModel.fromCredentials(credentials);
      final response = await _dio.post(
        ApiEndpoints.signUp,
        data: jsonEncode(requestModel.toJson()),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final result = SignUpResultModel.fromJson(response.data);
        return DataSuccess(result);
      } else {
        return DataError('Failed to sign up: ${response.statusMessage}');
      }
    } catch (e) {
      return DataError('An error occurred: $e');
    }
  }

  @override
  Future<DataState<SignUpResultEntity>> activateAccount(
      ActivateAccountCredentials credentials,
      ) async {
    try {
      final requestModel = ActivateAccountRequestModel.fromCredentials(credentials);
      final response = await _dio.post(
        ApiEndpoints.activateAccount,
        data: jsonEncode(requestModel.toJson()),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final result = SignUpResultModel.fromJson(response.data);
        return DataSuccess(result);
      } else {
        return DataError('Failed to activate account: ${response.statusMessage}');
      }
    } catch (e) {
      return DataError('An error occurred: $e');
    }
  }
  @override
  Future<DataState<ResendActivationEntity>> resendActivation(String email) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.resendOTP,
        data: jsonEncode({'email': email}),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final model = ResendActivationModel.fromJson(response.data);
        return DataSuccess(model.toEntity());
      } else {
        return DataError('Erreur lors de la réinitialisation du code');
      }
    } catch (e) {
      return DataError('Erreur lors de la réinitialisation du code: $e');
    }
  }

  @override
  Future<DataState<LoginResultEntity>> login(LoginCredentials credentials) async {
    try {
      final requestModel = LoginRequestModel.fromCredentials(credentials);
      final response = await _dio.post(
        ApiEndpoints.signIn,
        data: jsonEncode(requestModel.toJson()),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final result = LoginResultModel.fromJson(response.data);
        return DataSuccess(result.toEntity());
      } else {
        return DataError('Failed to login: ${response.statusMessage}');
      }
    } catch (e) {
      return DataError('An error occurred: $e');
    }
  }
}
