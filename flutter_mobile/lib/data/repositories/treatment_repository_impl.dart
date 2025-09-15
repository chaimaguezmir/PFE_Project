// lib/data/repositories/treatment_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/data/data_sources/treatment_remote_datasource.dart';
import 'package:flutter_mobile/data/model/prescription/create_treatment_request_model.dart';
import 'package:flutter_mobile/domain/entities/prescription/treatment_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_treatment_entity.dart';
import 'package:flutter_mobile/domain/repositories/treatment_repository.dart';

class TreatmentRepositoryImpl implements TreatmentRepository {
  TreatmentRepositoryImpl(this._remoteDataSource);

  final TreatmentRemoteDataSource _remoteDataSource;

  @override
  Future<DataState<List<TreatmentEntity>>> getTreatmentsByPrescriptionId(String prescriptionId) async {
    try {
      final result = await _remoteDataSource.getTreatmentsByPrescriptionId(prescriptionId);
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<TreatmentEntity>> getTreatmentById(String id) async {
    try {
      final result = await _remoteDataSource.getTreatmentById(id);
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<TreatmentEntity>> createTreatment(
      CreateTreatmentEntity treatment,
      ) async {
    try {
      // Convert entity to request model
      final requestModel = CreateTreatmentRequestModel(
        prescriptionId: treatment.prescriptionId,
        myMedicineId: treatment.myMedicineId,
        dosage: treatment.dosage,
        frequency: treatment.frequency,
        durationDays: treatment.durationDays,
      );

      final result = await _remoteDataSource.createTreatment(requestModel);
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<TreatmentEntity>> updateTreatment({
    required String id,
    String? dosage,
    String? frequency,
    int? durationDays,
  }) async {
    try {
      final result = await _remoteDataSource.updateTreatment(
        id: id,
        dosage: dosage,
        frequency: frequency,
        durationDays: durationDays,
      );
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('Une erreur inattendue s\'est produite: $e');
    }
  }

  @override
  Future<DataState<void>> deleteTreatment(String id) async {
    try {
      await _remoteDataSource.deleteTreatment(id);
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