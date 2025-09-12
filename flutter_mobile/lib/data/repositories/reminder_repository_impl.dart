// lib/data/repositories/reminder_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/data/model/prescription/create_reminder_request_model.dart';
import 'package:flutter_mobile/data/model/prescription/reminder_time_model.dart';
import 'package:flutter_mobile/data/model/reminder/simple_create_reminder_request_model.dart';
import 'package:flutter_mobile/domain/entities/reminder/reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/reminder/simple_reminder_entity.dart';
import 'package:flutter_mobile/domain/repositories/reminder_repository.dart';

import '../../domain/entities/reminder/simple_create_reminder_entity.dart' show SimpleCreateReminderEntity;
import '../data_sources/reminder_remote_data_source.dart' show ReminderRemoteDataSource;

class ReminderRepositoryImpl implements ReminderRepository {
  ReminderRepositoryImpl(this._remoteDataSource);

  final ReminderRemoteDataSource _remoteDataSource;

  @override
  Future<DataState<List<SimpleReminderEntity>>> createReminders(
      SimpleCreateReminderEntity reminderRequest,
      ) async {
    try {
      final requestModel = SimpleCreateReminderRequestModel.fromEntity(
        reminderRequest,
      );
      final responseModels = await _remoteDataSource.createReminders(
        requestModel,
      );
      final entities = responseModels.map((m) => m.toEntity()).toList();
      return DataSuccess(entities);
    } on DioException catch (e) {
      return DataError('Failed to create reminders:  {e.message}');
    } catch (e) {
      return DataError('Unexpected error: $e');
    }
  }

  @override
  Future<DataState<List<ReminderEntity>>> getRemindersWithMedications() async {
    try {
      final result = await _remoteDataSource.getRemindersWithMedications();
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<List<ReminderEntity>>> getRemindersByTreatmentId(String treatmentId) async {
    try {
      final result = await _remoteDataSource.getRemindersByTreatmentId(treatmentId);
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<ReminderEntity>> getReminderById(String id) async {
    try {
      final result = await _remoteDataSource.getReminderById(id);
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }


  @override
  Future<DataState<ReminderEntity>> updateReminder({
    required String id,
    String? customMessage,
    DateTime? reminderTime,
    String? status,
  }) async {
    try {
      final result = await _remoteDataSource.updateReminder(
        id: id,
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

  @override
  Future<DataState<void>> deleteReminder(String id) async {
    try {
      await _remoteDataSource.deleteReminder(id);
      return DataSuccess(null);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<ReminderEntity>> markReminderAsTaken(String id) async {
    try {
      final result = await _remoteDataSource.markReminderAsTaken(id);
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<ReminderEntity>> snoozeReminder(String id, Duration snoozeDuration) async {
    try {
      final result = await _remoteDataSource.snoozeReminder(id, snoozeDuration);
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
          return 'Données de rappel invalides.';
        } else if (error.response?.statusCode == 401) {
          return 'Non autorisé.';
        } else if (error.response?.statusCode == 404) {
          return 'Rappel non trouvé.';
        } else if (error.response?.statusCode == 409) {
          return 'Un rappel pour cette heure existe déjà.';
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