import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/data/data_sources/treatment_remote_datasource.dart';
import 'package:flutter_mobile/domain/entities/prescription/treatment_entity.dart';
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
  Future<DataState<TreatmentEntity>> createTreatment({
    required String prescriptionId,
    required String myMedicineId,
    required String dosage,
    required String frequency,
    required int durationDays,
  }) async {
    try {
      final result = await _remoteDataSource.createTreatment(
        prescriptionId: prescriptionId,
        myMedicineId: myMedicineId,
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