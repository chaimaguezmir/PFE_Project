import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/domain/entities/sign_up_credentials.dart';
import 'package:flutter_mobile/domain/entities/sign_up_result_entity.dart';
import 'package:flutter_mobile/domain/repositories/auth_repository.dart';
import 'package:flutter_mobile/data/model/sign_up_request_model.dart';
import 'package:flutter_mobile/data/model/sign_up_result_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({Dio? dio}) : dio = dio ?? Dio();
  final Dio dio;

  @override
  Future<DataState<SignUpResultEntity>> signUp(
    SignUpCredentials credentials,
  ) async {
    try {
      final requestModel = SignUpRequestModel.fromCredentials(credentials);
      final response = await dio.post(
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
}
