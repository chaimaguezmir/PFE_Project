import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/data/model/auth/activate_account_request_model.dart';
import 'package:flutter_mobile/domain/entities/auth/activate_account_credentials.dart';
import 'package:flutter_mobile/domain/entities/auth/sign_up_credentials.dart';
import 'package:flutter_mobile/domain/entities/auth/sign_up_result_entity.dart';
import 'package:flutter_mobile/domain/repositories/auth_repository.dart';
import 'package:flutter_mobile/data/model/auth/sign_up_request_model.dart';
import 'package:flutter_mobile/data/model/auth/sign_up_result_model.dart';

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
        ApiEndpoints.activateAccount, // e.g., '/activate'
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
}
