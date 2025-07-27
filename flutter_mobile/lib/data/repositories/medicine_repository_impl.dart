import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/data/data_sources/medicine_remote_datasource.dart';
import 'package:flutter_mobile/domain/entities/services/medicine_entity.dart';
import 'package:flutter_mobile/domain/entities/services/my_medicine_entity.dart';
import 'package:flutter_mobile/domain/repositories/medicine_repository.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  MedicineRepositoryImpl(this._remoteDataSource);

  final MedicineRemoteDataSource _remoteDataSource;

  @override
  Future<DataState<List<MyMedicineEntity>>> getMyMedicines(String pharmacyBoxId) async {
    try {
      final result = await _remoteDataSource.getMyMedicines(pharmacyBoxId);
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('An unexpected error occurred: $e');
    }
  }
  @override
  Future<DataState<MedicineEntity>> getMedicineByBarcode(String barcode) async {
    try {
      final result = await _remoteDataSource.getMedicineByBarcode(barcode);
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataError(_handleDioError(e));
    } catch (e) {
      return DataError('An unexpected error occurred: $e');
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
          return 'Médicaments non trouvés.';
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