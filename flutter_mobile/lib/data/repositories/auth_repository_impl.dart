import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/data/data_sources/auth_remote_datasource.dart';
import 'package:flutter_mobile/data/model/auth/activate_account/activate_account_request_model.dart';
import 'package:flutter_mobile/data/model/auth/activate_account/resend_activation_model.dart';
import 'package:flutter_mobile/data/model/auth/forgot_password/check_reset_code_result_model.dart';
import 'package:flutter_mobile/data/model/auth/forgot_password/forgot_password_result_model.dart';
import 'package:flutter_mobile/data/model/auth/login/login_request_model.dart';
import 'package:flutter_mobile/data/model/auth/login/login_result_model.dart';
import 'package:flutter_mobile/data/model/auth/signup/sign_up_request_model.dart';
import 'package:flutter_mobile/data/model/auth/signup/sign_up_result_model.dart';
import 'package:flutter_mobile/domain/entities/auth/activate_account_credentials.dart';
import 'package:flutter_mobile/domain/entities/auth/check_reset_code_result_entity.dart';
import 'package:flutter_mobile/domain/entities/auth/forgot_password_result_entity.dart';
import 'package:flutter_mobile/domain/entities/auth/login_credentials.dart';
import 'package:flutter_mobile/domain/entities/auth/login_result_entity.dart';
import 'package:flutter_mobile/domain/entities/auth/resend_activation_entity.dart';
import 'package:flutter_mobile/domain/entities/auth/sign_up_credentials.dart';
import 'package:flutter_mobile/domain/entities/auth/sign_up_result_entity.dart';
import 'package:flutter_mobile/domain/repositories/auth_repository.dart';
/// Implementation of [AuthRepository] using remote data source
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<DataState<SignUpResultEntity>> signUp(
      SignUpCredentials credentials,
      ) async {
    try {
      final requestModel = SignUpRequestModel.fromCredentials(credentials);
      final result = await _remoteDataSource.signUp(requestModel);
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('An unexpected error occurred: $e');
    }
  }

  @override
  Future<DataState<SignUpResultEntity>> activateAccount(
      ActivateAccountCredentials credentials,
      ) async {
    try {
      final requestModel = ActivateAccountRequestModel.fromCredentials(
        credentials,
      );
      final result = await _remoteDataSource.activateAccount(requestModel);
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('An unexpected error occurred: $e');
    }
  }

  @override
  Future<DataState<ResendActivationEntity>> resendActivation(
      String email,
      ) async {
    try {
      final result = await _remoteDataSource.resendActivation(email);
      return DataSuccess(result.toEntity());
    } on DioException catch (e) {
      return DataError(_handleDioError(e, 'Erreur lors de la réinitialisation du code'));
    } catch (e) {
      return DataError('Erreur lors de la réinitialisation du code: $e');
    }
  }

  @override
  Future<DataState<LoginResultEntity>> login(
      LoginCredentials credentials,
      ) async {
    try {
      final requestModel = LoginRequestModel.fromCredentials(credentials);
      final result = await _remoteDataSource.signIn(requestModel);
      return DataSuccess(result.toEntity());
    } on DioException catch (e) {

      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('An unexpected error occurred: $e');
    }
  }

  @override
  Future<DataState<ForgotPasswordResultEntity>> forgotPassword(
      String email,
      ) async {
    try {
      final result = await _remoteDataSource.forgotPassword(email);
      return DataSuccess(result.toEntity());
    } on DioException catch (e) {
      return DataError(_handleDioError(e, 'Erreur lors de l\'envoi de l\'e-mail de réinitialisation'));
    } catch (e) {
      return DataError('Erreur lors de l\'envoi de l\'e-mail: $e');
    }
  }

  @override
  Future<DataState<CheckResetCodeResultEntity>> checkResetCode(
      String email,
      String otp,
      ) async {
    try {
      final result = await _remoteDataSource.checkResetCode(email, otp);
      return DataSuccess(result.toEntity());
    } on DioException catch (e) {
      return DataError(_handleDioError(e, 'Code invalide'));
    } catch (e) {
      return DataError('Erreur lors de la vérification du code: $e');
    }
  }

  @override
  Future<DataState<ForgotPasswordResultEntity>> resetPassword(
      String email,
      String otp,
      String password,
      ) async {
    try {
      final result = await _remoteDataSource.resetPassword(email, otp, password);
      return DataSuccess(result.toEntity());
    } on DioException catch (e) {
      return DataError(_handleDioError(e, 'Erreur lors de la réinitialisation du mot de passe'));
    } catch (e) {
      return DataError('Erreur lors de la réinitialisation du mot de passe: $e');
    }
  }

  /// Handles DioException and returns appropriate error message
  String _handleDioError(DioException error, [String? defaultMessage]) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Délai de connexion dépassé. Vérifiez votre connexion internet.';

      case DioExceptionType.connectionError:
        return 'Erreur de connexion. Vérifiez votre connexion internet.';

      case DioExceptionType.badResponse:
        if (error.response?.statusCode == 400) {
          return 'Données invalides. Veuillez vérifier vos informations.';
        } else if (error.response?.statusCode == 401) {
          return 'Identifiants incorrects.';
        } else if (error.response?.statusCode == 404) {
          return 'Service non disponible.';
        } else if (error.response?.statusCode == 500) {
          return 'Erreur du serveur. Veuillez réessayer plus tard.';
        }
        return defaultMessage ?? 'Erreur de réponse du serveur.';

      case DioExceptionType.cancel:
        return 'Opération annulée.';

      case DioExceptionType.unknown:
      default:
        return defaultMessage ?? 'Une erreur inattendue s\'est produite.';
    }
  }
}