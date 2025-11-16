import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/data/data_sources/user_reminder_remote_data_source.dart';
import 'package:flutter_mobile/data/model/reminder/simple_create_reminder_request_model.dart';
import 'package:flutter_mobile/domain/entities/reminder/reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/reminder/simple_create_reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/reminder/simple_reminder_entity.dart';
import 'package:flutter_mobile/domain/repositories/user_reminder_repository.dart';

class UserReminderRepositoryImpl implements UserReminderRepository {
  UserReminderRepositoryImpl(this._remoteDataSource);

  final UserReminderRemoteDataSource _remoteDataSource;

  @override
  Future<DataState<List<ReminderEntity>>> getUserRemindersWithMedications({
    required String groupId,
    required String userId,
  }) async {
    try {
      final result = await _remoteDataSource.getUserRemindersWithMedications(
        groupId: groupId,
        userId: userId,
      );
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<List<ReminderEntity>>> getUserReminders({
    required String groupId,
    required String userId,
  }) async {
    try {
      final result = await _remoteDataSource.getUserReminders(
        groupId: groupId,
        userId: userId,
      );
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<List<SimpleReminderEntity>>> createUserReminders({
    required String groupId,
    required String userId,
    required SimpleCreateReminderEntity createReminderEntity,
  }) async {
    try {
      final request = SimpleCreateReminderRequestModel.fromEntity(createReminderEntity);
      final result = await _remoteDataSource.createUserReminders(
        groupId: groupId,
        userId: userId,
        request: request,
      );
      return DataSuccess(result.map((model) => model.toEntity()).toList());
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<ReminderEntity>> getUserReminderById({
    required String groupId,
    required String userId,
    required String reminderId,
  }) async {
    try {
      final result = await _remoteDataSource.getUserReminderById(
        groupId: groupId,
        userId: userId,
        reminderId: reminderId,
      );
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<ReminderEntity>> markUserReminderAsTaken({
    required String groupId,
    required String userId,
    required String reminderId,
  }) async {
    try {
      final result = await _remoteDataSource.markUserReminderAsTaken(
        groupId: groupId,
        userId: userId,
        reminderId: reminderId,
      );
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<ReminderEntity>> updateUserReminder({
    required String groupId,
    required String userId,
    required String reminderId,
    String? customMessage,
    DateTime? reminderTime,
    String? status,
  }) async {
    try {
      final result = await _remoteDataSource.updateUserReminder(
        groupId: groupId,
        userId: userId,
        reminderId: reminderId,
        customMessage: customMessage,
        reminderTime: reminderTime,
        status: status,
      );
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
        return 'Délai de connexion dépassé. Vérifiez votre connexion Internet.';
      case DioExceptionType.badResponse:
        if (error.response?.statusCode == 400) {
          return 'Données de rappel invalides.';
        } else if (error.response?.statusCode == 401) {
          return 'Non autorisé.';
        } else if (error.response?.statusCode == 403) {
          return 'Accès refusé. Vous n\'avez pas les permissions nécessaires.';
        } else if (error.response?.statusCode == 404) {
          return 'Rappel non trouvé.';
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