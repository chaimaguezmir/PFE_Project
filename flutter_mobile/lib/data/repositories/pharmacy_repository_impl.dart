import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/data/data_sources/pharmacy_remote_datasource.dart';
import 'package:flutter_mobile/domain/entities/services/PharmacyBoxEntity.dart';
import 'package:flutter_mobile/domain/repositories/pharmacy_repository.dart';

class PharmacyRepositoryImpl implements PharmacyRepository {
  PharmacyRepositoryImpl(this._remoteDataSource);

  final PharmacyRemoteDataSource _remoteDataSource;

  @override
  Future<DataState<List<PharmacyBoxEntity>>> getMyPharmacyBoxes() async {
    try {
      final result = await _remoteDataSource.getMyPharmacyBoxes();
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
          return 'Service non disponible.';
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