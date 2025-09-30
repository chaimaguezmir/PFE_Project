// lib/data/repositories/profile_repository_impl.dart

import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/data/data_sources/profile_remote_datasource.dart';
import 'package:flutter_mobile/data/model/profile/update_profile_request_model.dart';
import 'package:flutter_mobile/domain/entities/profile/upload_image_entity.dart';
import 'package:flutter_mobile/domain/entities/profile/user_profile_entity.dart';
import 'package:flutter_mobile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<DataState<UploadImageEntity>> uploadProfileImage(String filePath) async {
    try {
      final result = await _remoteDataSource.uploadProfileImage(filePath);
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<UserProfileEntity>> getUserProfile() async {
    try {
      final result = await _remoteDataSource.getUserProfile();
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<UserProfileEntity>> updateUserProfile(
      UpdateProfileEntity profile,
      ) async {
    try {
      final request = UpdateProfileRequestModel.fromEntity(profile);
      final result = await _remoteDataSource.updateUserProfile(request);
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Délai de connexion dépassé. Vérifiez votre connexion internet.';

      case DioExceptionType.connectionError:
        return 'Erreur de connexion. Vérifiez votre connexion internet.';

      case DioExceptionType.badResponse:
        if (error.response?.statusCode == 400) {
          final message = error.response?.data['message'];
          return message ?? 'Données invalides.';
        } else if (error.response?.statusCode == 401) {
          return 'Non autorisé. Veuillez vous reconnecter.';
        } else if (error.response?.statusCode == 413) {
          return 'Fichier trop volumineux.';
        } else if (error.response?.statusCode == 500) {
          return 'Erreur du serveur. Veuillez réessayer plus tard.';
        }
        return 'Erreur de réponse du serveur.';

      case DioExceptionType.cancel:
        return 'Opération annulée.';

      case DioExceptionType.unknown:
      default:
        return 'Une erreur inattendue s\'est produite.';
    }
  }
}