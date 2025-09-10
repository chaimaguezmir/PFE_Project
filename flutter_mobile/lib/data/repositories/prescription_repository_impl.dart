// lib/data/repositories/prescription_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/data/data_sources/prescription_remote_datasource.dart';
import 'package:flutter_mobile/data/model/prescription/create_prescription_request_model.dart';
import 'package:flutter_mobile/domain/entities/prescription/prescription_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_prescription_entity.dart';
import 'package:flutter_mobile/domain/repositories/prescription_repository.dart';

class PrescriptionRepositoryImpl implements PrescriptionRepository {
  PrescriptionRepositoryImpl(this._remoteDataSource);

  final PrescriptionRemoteDataSource _remoteDataSource;

  @override
  Future<DataState<List<PrescriptionEntity>>> getPrescriptions() async {
    try {
      final result = await _remoteDataSource.getPrescriptions();
      // FIXED: Convert PrescriptionModel list to PrescriptionEntity list
      final entities = result.map((model) => model.toEntity()).toList();
      return DataSuccess(entities);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<PrescriptionEntity>> getPrescriptionById(String id) async {
    try {
      final result = await _remoteDataSource.getPrescriptionById(id);
      // FIXED: Convert PrescriptionModel to PrescriptionEntity
      return DataSuccess(result.toEntity());
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<PrescriptionEntity>> createPrescription(
      CreatePrescriptionEntity prescription,
      ) async {
    try {
      // Convert entity to request model
      final requestModel = CreatePrescriptionRequestModel(
        name: prescription.name,
        diseaseIds: prescription.diseaseIds,
      );

      final result = await _remoteDataSource.createPrescription(requestModel);
      // FIXED: Convert PrescriptionModel to PrescriptionEntity
      return DataSuccess(result.toEntity());
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<PrescriptionEntity>> updatePrescription({
    required String id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final result = await _remoteDataSource.updatePrescription(
        id: id,
        name: name,
        startDate: startDate,
        endDate: endDate,
      );
      // FIXED: Convert PrescriptionModel to PrescriptionEntity
      return DataSuccess(result.toEntity());
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<void>> deletePrescription(String id) async {
    try {
      await _remoteDataSource.deletePrescription(id);
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