import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/data/data_sources/medicine_remote_datasource.dart';
import 'package:flutter_mobile/data/model/services/medicine_model.dart';
import 'package:flutter_mobile/data/model/services/my_medicine_model.dart';

class MedicineRemoteDataSourceImpl implements MedicineRemoteDataSource {
  MedicineRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<MyMedicineModel>> getMyMedicines(String pharmacyBoxId) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.baseurl}/my-medicines/pharmacy-box/$pharmacyBoxId',
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((json) => MyMedicineModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch medicines: ${response.statusMessage}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(
          path: '${ApiEndpoints.baseurl}/my-medicines/pharmacy-box/$pharmacyBoxId',
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }
  @override
  Future<MedicineModel> getMedicineByBarcode(String barcode) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.baseurl}/medicines/barcode/$barcode',
      );

      if (response.statusCode == 200) {
        return MedicineModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Medicine not found for barcode: $barcode',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(
          path: '${ApiEndpoints.baseurl}/medicines/barcode/$barcode',
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}