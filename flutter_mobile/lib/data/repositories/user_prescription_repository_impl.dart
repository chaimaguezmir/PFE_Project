import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/data/data_sources/user_prescription_remote_data_source.dart';
import 'package:flutter_mobile/data/model/prescription/create_prescription_request_model.dart';
import 'package:flutter_mobile/domain/entities/prescription/prescription_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_prescription_entity.dart';
import 'package:flutter_mobile/domain/repositories/user_prescription_repository.dart';

class UserPrescriptionRepositoryImpl implements UserPrescriptionRepository {
  UserPrescriptionRepositoryImpl(this._remoteDataSource);

  final UserPrescriptionRemoteDataSource _remoteDataSource;

  @override
  Future<DataState<List<PrescriptionEntity>>> getUserPrescriptions({
    required String groupId,
    required String userId,
  }) async {
    try {
      final result = await _remoteDataSource.getUserPrescriptions(
        groupId: groupId,
        userId: userId,
      );
      // Convert PrescriptionModel list to PrescriptionEntity list
      final entities = result.map((model) => model.toEntity()).toList();
      return DataSuccess(entities);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<PrescriptionEntity>> getUserPrescriptionById({
    required String groupId,
    required String userId,
    required String prescriptionId,
  }) async {
    try {
      final result = await _remoteDataSource.getUserPrescriptionById(
        groupId: groupId,
        userId: userId,
        prescriptionId: prescriptionId,
      );
      // Convert PrescriptionModel to PrescriptionEntity
      return DataSuccess(result.toEntity());
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<PrescriptionEntity>> createUserPrescription({
    required String groupId,
    required String userId,
    required CreatePrescriptionEntity createPrescriptionEntity,
  }) async {
    try {
      // Convert entity to request model
      final requestModel = CreatePrescriptionRequestModel(
        name: createPrescriptionEntity.name,
        diseaseIds: createPrescriptionEntity.diseaseIds,
      );

      final result = await _remoteDataSource.createUserPrescription(
        groupId: groupId,
        userId: userId,
        request: requestModel,
      );
      // Convert PrescriptionModel to PrescriptionEntity
      return DataSuccess(result.toEntity());
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<PrescriptionEntity>> updateUserPrescription({
    required String groupId,
    required String userId,
    required String prescriptionId,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final result = await _remoteDataSource.updateUserPrescription(
        groupId: groupId,
        userId: userId,
        prescriptionId: prescriptionId,
        name: name,
        startDate: startDate,
        endDate: endDate,
      );
      // Convert PrescriptionModel to PrescriptionEntity
      return DataSuccess(result.toEntity());
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<void>> deleteUserPrescription({
    required String groupId,
    required String userId,
    required String prescriptionId,
  }) async {
    try {
      await _remoteDataSource.deleteUserPrescription(
        groupId: groupId,
        userId: userId,
        prescriptionId: prescriptionId,
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
          return 'Prescription non trouvée.';
        } else if (error.response?.statusCode == 409) {
          return 'Une prescription avec ce nom existe déjà.';
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