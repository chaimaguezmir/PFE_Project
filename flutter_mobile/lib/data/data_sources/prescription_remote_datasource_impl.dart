// lib/data/data_sources/prescription_remote_datasource_impl.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/data/data_sources/prescription_remote_datasource.dart';
import 'package:flutter_mobile/data/model/prescription/prescription_model.dart';
import 'package:flutter_mobile/data/model/prescription/create_prescription_request_model.dart';

class PrescriptionRemoteDataSourceImpl implements PrescriptionRemoteDataSource {
  PrescriptionRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<PrescriptionModel>> getPrescriptions() async {
    try {
      print('Fetching prescriptions from API');
      final response = await _dio.get(ApiEndpoints.prescriptions);

      if (response.statusCode == 200) {
        final data = response.data as List;
        print('Successfully fetched ${data.length} prescriptions');

        // ADDED: Debug logging for the raw data
        print(
          'Raw prescription data sample: ${data.isNotEmpty ? data.first : 'No data'}',
        );

        final List<PrescriptionModel> prescriptions = [];

        // ADDED: Process each prescription with error handling
        for (int i = 0; i < data.length; i++) {
          try {
            final prescriptionJson = data[i];
            print(
              'Processing prescription $i: ${prescriptionJson['id'] ?? 'no-id'}',
            );

            // ADDED: Validate required fields before parsing
            if (prescriptionJson == null) {
              print('Warning: Prescription at index $i is null, skipping');
              continue;
            }

            if (prescriptionJson is! Map<String, dynamic>) {
              print(
                'Warning: Prescription at index $i is not a valid map, skipping',
              );
              continue;
            }

            final prescription = PrescriptionModel.fromJson(prescriptionJson);
            prescriptions.add(prescription);

            print(
              'Successfully parsed prescription: ${prescription.id} - ${prescription.name}',
            );
          } catch (e, stackTrace) {
            print('ERROR parsing prescription at index $i: $e');
            print('Stack trace: $stackTrace');
            print('Raw data: ${data[i]}');
            // Continue processing other prescriptions instead of failing completely
          }
        }

        print(
          'Successfully parsed ${prescriptions.length} out of ${data.length} prescriptions',
        );
        return prescriptions;
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
    } catch (e, stackTrace) {
      print('Unexpected error in getPrescriptions: $e');
      print('Stack trace: $stackTrace');
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.prescriptions),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<PrescriptionModel> getPrescriptionById(String id) async {
    try {
      print('Fetching prescription by ID: $id');
      final response = await _dio.get(ApiEndpoints.prescriptionById(id));

      if (response.statusCode == 200) {
        print('Successfully fetched prescription: $id');

        // ADDED: Debug logging
        print('Raw prescription data: ${response.data}');

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
    } catch (e, stackTrace) {
      print('Unexpected error in getPrescriptionById: $e');
      print('Stack trace: $stackTrace');
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.prescriptionById(id)),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<PrescriptionModel> createPrescription(
    CreatePrescriptionRequestModel request,
  ) async {
    try {
      print('Creating new prescription: ${request.name}');
      print('Request data: ${request.toJson()}');

      final response = await _dio.post(
        ApiEndpoints.prescriptions,
        data: request.toJson(),
      );

      print('Create prescription response status: ${response.statusCode}');
      print('Create prescription response data: ${response.data}');

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
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      rethrow;
    } catch (e, stackTrace) {
      print('Unexpected error in createPrescription: $e');
      print('Stack trace: $stackTrace');
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.prescriptions),
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
      if (startDate != null)
        requestData['startDate'] = startDate.toIso8601String().split('T')[0];
      if (endDate != null)
        requestData['endDate'] = endDate.toIso8601String().split('T')[0];

      print('Update request data: $requestData');

      final response = await _dio.put(
        ApiEndpoints.prescriptionById(id),
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
    } catch (e, stackTrace) {
      print('Unexpected error in updatePrescription: $e');
      print('Stack trace: $stackTrace');
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.prescriptionById(id)),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<void> deletePrescription(String id) async {
    try {
      print('Deleting prescription: $id');
      final response = await _dio.delete(ApiEndpoints.prescriptionById(id));

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
    } catch (e, stackTrace) {
      print('Unexpected error in deletePrescription: $e');
      print('Stack trace: $stackTrace');
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.prescriptionById(id)),
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
