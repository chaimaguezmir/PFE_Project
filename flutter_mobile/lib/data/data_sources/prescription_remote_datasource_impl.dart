import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/data/data_sources/prescription_remote_datasource.dart';
import 'package:flutter_mobile/data/model/prescription/prescription_model.dart';

class PrescriptionRemoteDataSourceImpl implements PrescriptionRemoteDataSource {
  PrescriptionRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<PrescriptionModel>> getPrescriptions() async {
    try {
      print('Fetching prescriptions from API');
      final response = await _dio.get('${ApiEndpoints.baseurl}/prescriptions');

      if (response.statusCode == 200) {
        final data = response.data as List;
        print('Successfully fetched ${data.length} prescriptions');
        return data.map((json) => PrescriptionModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch prescriptions: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in getPrescriptions: ${e.message}');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Unexpected error in getPrescriptions: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '${ApiEndpoints.baseurl}/prescriptions'),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<PrescriptionModel> getPrescriptionById(String id) async {
    try {
      print('Fetching prescription by ID: $id');
      final response = await _dio.get('${ApiEndpoints.baseurl}/prescriptions/$id');

      if (response.statusCode == 200) {
        print('Successfully fetched prescription: $id');
        return PrescriptionModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch prescription: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in getPrescriptionById: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in getPrescriptionById: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '${ApiEndpoints.baseurl}/prescriptions/$id'),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<PrescriptionModel> createPrescription({
    required String name,
    required DateTime startDate,
    DateTime? endDate,
    required List<String> diseaseIds,
  }) async {
    try {
      print('Creating new prescription: $name');
      final requestData = {
        'name': name,
        'startDate': startDate.toIso8601String().split('T')[0],
        if (endDate != null) 'endDate': endDate.toIso8601String().split('T')[0],
        'diseaseIds': diseaseIds,
      };

      final response = await _dio.post(
        '${ApiEndpoints.baseurl}/prescriptions',
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Successfully created prescription');
        return PrescriptionModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to create prescription: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in createPrescription: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in createPrescription: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '${ApiEndpoints.baseurl}/prescriptions'),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<PrescriptionModel> updatePrescription({
    required String id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      print('Updating prescription: $id');
      final requestData = <String, dynamic>{};

      if (name != null) requestData['name'] = name;
      if (startDate != null) requestData['startDate'] = startDate.toIso8601String().split('T')[0];
      if (endDate != null) requestData['endDate'] = endDate.toIso8601String().split('T')[0];

      final response = await _dio.put(
        '${ApiEndpoints.baseurl}/prescriptions/$id',
        data: requestData,
      );

      if (response.statusCode == 200) {
        print('Successfully updated prescription');
        return PrescriptionModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to update prescription: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in updatePrescription: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in updatePrescription: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '${ApiEndpoints.baseurl}/prescriptions/$id'),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<void> deletePrescription(String id) async {
    try {
      print('Deleting prescription: $id');
      final response = await _dio.delete('${ApiEndpoints.baseurl}/prescriptions/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to delete prescription: ${response.statusMessage}',
        );
      }
      print('Successfully deleted prescription');
    } on DioException catch (e) {
      print('DioException in deletePrescription: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in deletePrescription: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '${ApiEndpoints.baseurl}/prescriptions/$id'),
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}