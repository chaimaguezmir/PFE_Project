import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/data/data_sources/user_treatment_remote_data_source.dart';
import 'package:flutter_mobile/data/model/prescription/create_treatment_request_model.dart';
import 'package:flutter_mobile/domain/entities/prescription/treatment_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_treatment_entity.dart';
import 'package:flutter_mobile/domain/repositories/user_treatment_repository.dart';

class UserTreatmentRepositoryImpl implements UserTreatmentRepository {
  UserTreatmentRepositoryImpl(this._remoteDataSource);

  final UserTreatmentRemoteDataSource _remoteDataSource;

  @override
  Future<DataState<List<TreatmentEntity>>> getUserTreatments({
    required String groupId,
    required String userId,
  }) async {
    try {
      final result = await _remoteDataSource.getUserTreatments(
        groupId: groupId,
        userId: userId,
      );
      // TreatmentModel extends TreatmentEntity, so no conversion needed
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<List<TreatmentEntity>>> getUserTreatmentsByPrescription({
    required String groupId,
    required String userId,
    required String prescriptionId,
  }) async {
    try {
      final result = await _remoteDataSource.getUserTreatmentsByPrescription(
        groupId: groupId,
        userId: userId,
        prescriptionId: prescriptionId,
      );
      // TreatmentModel extends TreatmentEntity, so no conversion needed
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<TreatmentEntity>> getUserTreatmentById({
    required String groupId,
    required String userId,
    required String treatmentId,
  }) async {
    try {
      final result = await _remoteDataSource.getUserTreatmentById(
        groupId: groupId,
        userId: userId,
        treatmentId: treatmentId,
      );
      // TreatmentModel extends TreatmentEntity, so no conversion needed
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<TreatmentEntity>> createUserTreatment({
    required String groupId,
    required String userId,
    required CreateTreatmentEntity createTreatmentEntity,
  }) async {
    try {
      // Convert entity to request model (same as regular treatment repository)
      final requestModel = CreateTreatmentRequestModel(
        prescriptionId: createTreatmentEntity.prescriptionId,
        myMedicineId: createTreatmentEntity.myMedicineId,
        dosage: createTreatmentEntity.dosage,
        frequency: createTreatmentEntity.frequency,
        durationDays: createTreatmentEntity.durationDays,
      );

      final result = await _remoteDataSource.createUserTreatment(
        groupId: groupId,
        userId: userId,
        request: requestModel,
      );
      // TreatmentModel extends TreatmentEntity, so no conversion needed
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<TreatmentEntity>> updateUserTreatment({
    required String groupId,
    required String userId,
    required String treatmentId,
    String? dosage,
    String? frequency,
    int? durationDays,
  }) async {
    try {
      final result = await _remoteDataSource.updateUserTreatment(
        groupId: groupId,
        userId: userId,
        treatmentId: treatmentId,
        dosage: dosage,
        frequency: frequency,
        durationDays: durationDays,
      );
      // TreatmentModel extends TreatmentEntity, so no conversion needed
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<void>> deleteUserTreatment({
    required String groupId,
    required String userId,
    required String treatmentId,
  }) async {
    try {
      await _remoteDataSource.deleteUserTreatment(
        groupId: groupId,
        userId: userId,
        treatmentId: treatmentId,
      );
      return DataSuccess(null);
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
          return 'Données invalides.';
        } else if (error.response?.statusCode == 401) {
          return 'Non autorisé.';
        } else if (error.response?.statusCode == 403) {
          return 'Accès refusé. Vous n\'avez pas les permissions nécessaires.';
        } else if (error.response?.statusCode == 404) {
          return 'Traitement non trouvé.';
        } else if (error.response?.statusCode == 409) {
          return 'Un traitement pour ce médicament existe déjà dans cette prescription.';
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