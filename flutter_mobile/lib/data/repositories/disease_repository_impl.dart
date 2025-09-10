// lib/data/repositories/disease_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/data/data_sources/disease_remote_datasource.dart';
import 'package:flutter_mobile/domain/entities/prescription/disease_entity.dart';
import 'package:flutter_mobile/domain/repositories/disease_repository.dart';

class DiseaseRepositoryImpl implements DiseaseRepository {
  DiseaseRepositoryImpl(this._remoteDataSource);
  final DiseaseRemoteDataSource _remoteDataSource;

  @override
  Future<DataState<List<DiseaseEntity>>> getDiseases() async {
    try {
      final result = await _remoteDataSource.getDiseases();
      final entities = result.map((model) => model.toEntity()).toList();
      return DataSuccess(entities);
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
        if (error.response?.statusCode == 404) {
          return 'Service des maladies non disponible.';
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