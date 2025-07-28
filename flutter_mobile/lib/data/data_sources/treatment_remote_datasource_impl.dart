import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/data/data_sources/treatment_remote_datasource.dart';
import 'package:flutter_mobile/data/model/prescription/treatment_model.dart';

class TreatmentRemoteDataSourceImpl implements TreatmentRemoteDataSource {
  TreatmentRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<TreatmentModel>> getTreatmentsByPrescriptionId(String prescriptionId) async {
    try {
      print('Fetching treatments for prescription: $prescriptionId');
      final response = await _dio.get('${ApiEndpoints.baseurl}/treatments/prescription/$prescriptionId');

      if (response.statusCode == 200) {
        final data = response.data as List;
        print('Successfully fetched ${data.length} treatments');
        return data.map((json) => TreatmentModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch treatments: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in getTreatmentsByPrescriptionId: ${e.message}');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Unexpected error in getTreatmentsByPrescriptionId: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: '${ApiEndpoints.baseurl}/treatments/prescription/$prescriptionId',
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<TreatmentModel> createTreatment({
    required String prescriptionId,
    required String myMedicineId,
    required String dosage,
    required String frequency,
    required int durationDays,
  }) async {
    try {
      print('Creating new treatment for prescription: $prescriptionId');
      final requestData = {
        'prescriptionId': prescriptionId,
        'myMedicineId': myMedicineId,
        'dosage': dosage,
        'frequency': frequency,
        'durationDays': durationDays,
      };

      final response = await _dio.post(
        '${ApiEndpoints.baseurl}/treatments',
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Successfully created treatment');
        return TreatmentModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to create treatment: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in createTreatment: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in createTreatment: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '${ApiEndpoints.baseurl}/treatments'),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<TreatmentModel> updateTreatment({
    required String id,
    String? dosage,
    String? frequency,
    int? durationDays,
  }) async {
    try {
      print('Updating treatment: $id');
      final requestData = <String, dynamic>{};

      if (dosage != null) requestData['dosage'] = dosage;
      if (frequency != null) requestData['frequency'] = frequency;
      if (durationDays != null) requestData['durationDays'] = durationDays;

      final response = await _dio.put(
        '${ApiEndpoints.baseurl}/treatments/$id',
        data: requestData,
      );

      if (response.statusCode == 200) {
        print('Successfully updated treatment');
        return TreatmentModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to update treatment: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in updateTreatment: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in updateTreatment: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '${ApiEndpoints.baseurl}/treatments/$id'),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<void> deleteTreatment(String id) async {
    try {
      print('Deleting treatment: $id');
      final response = await _dio.delete('${ApiEndpoints.baseurl}/treatments/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to delete treatment: ${response.statusMessage}',
        );
      }
      print('Successfully deleted treatment');
    } on DioException catch (e) {
      print('DioException in deleteTreatment: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in deleteTreatment: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '${ApiEndpoints.baseurl}/treatments/$id'),
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}