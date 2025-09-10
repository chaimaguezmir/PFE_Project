// lib/data/repositories/reminder_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/data/model/prescription/create_reminder_request_model.dart';
import 'package:flutter_mobile/data/model/prescription/reminder_time_model.dart';
import 'package:flutter_mobile/domain/entities/prescription/reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_reminder_entity.dart';
import 'package:flutter_mobile/domain/repositories/reminder_repository.dart';

import '../data_sources/reminder_remote_data_source.dart' show ReminderRemoteDataSource;

class ReminderRepositoryImpl implements ReminderRepository {
  ReminderRepositoryImpl(this._remoteDataSource);

  final ReminderRemoteDataSource _remoteDataSource;

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
  Future<DataState<List<ReminderEntity>>> createReminders(
      CreateReminderEntity reminderRequest,
      ) async {
    try {
      // Convert entity to request model
      final reminderTimeModels = reminderRequest.reminderTimes
          .map((timeEntity) => ReminderTimeModel(
        timeSlot: timeEntity.timeSlot,
        time: timeEntity.time,
      ))
          .toList();

      final requestModel = CreateReminderRequestModel(
        treatmentId: reminderRequest.treatmentId,
        reminderTimes: reminderTimeModels,
        customMessage: reminderRequest.customMessage,
        startPreference: reminderRequest.startPreference,
      );

      final result = await _remoteDataSource.createReminders(requestModel);
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