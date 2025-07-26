import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/data/data_sources/pharmacy_remote_datasource.dart';
import 'package:flutter_mobile/data/model/services/pharmacy_box_model.dart';

class PharmacyRemoteDataSourceImpl implements PharmacyRemoteDataSource {
  PharmacyRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<PharmacyBoxModel>> getMyPharmacyBoxes() async {
    try {
      final response = await _dio.get('${ApiEndpoints.baseurl}/pharmacy-box/mine',options: Options(
        receiveTimeout: const Duration(seconds: 5),
        sendTimeout: const Duration(seconds: 5),
      ),
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((json) => PharmacyBoxModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch pharmacy boxes: ${response.statusMessage}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '${ApiEndpoints.baseurl}/pharmacy-box/mine'),
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}