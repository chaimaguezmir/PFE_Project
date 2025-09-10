// lib/data/data_sources/disease_remote_datasource_impl.dart
import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/data/data_sources/disease_remote_datasource.dart';
import 'package:flutter_mobile/data/model/prescription/disease_model.dart';

class DiseaseRemoteDataSourceImpl implements DiseaseRemoteDataSource {
  DiseaseRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<DiseaseModel>> getDiseases() async {
    try {
      final response = await _dio.get('${ApiEndpoints.baseurl}/diseases');

      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((json) => DiseaseModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch diseases: ${response.statusMessage}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '${ApiEndpoints.baseurl}/diseases'),
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}