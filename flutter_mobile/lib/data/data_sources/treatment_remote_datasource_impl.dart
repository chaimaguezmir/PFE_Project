// lib/data/data_sources/treatment_remote_datasource_impl.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/data/data_sources/treatment_remote_datasource.dart';
import 'package:flutter_mobile/data/model/prescription/treatment_model.dart';
import 'package:flutter_mobile/data/model/prescription/create_treatment_request_model.dart';

class TreatmentRemoteDataSourceImpl implements TreatmentRemoteDataSource {
  TreatmentRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<TreatmentModel>> getTreatmentsByPrescriptionId(String prescriptionId) async {
    try {
      print('Fetching treatments for prescription: $prescriptionId');
      final response = await _dio.get(ApiEndpoints.treatmentsByPrescription(prescriptionId));

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
          path: ApiEndpoints.treatmentsByPrescription(prescriptionId),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<TreatmentModel> getTreatmentById(String id) async {
    try {
      print('Fetching treatment by ID: $id');
      final response = await _dio.get(ApiEndpoints.treatmentById(id));

      if (response.statusCode == 200) {
        print('Successfully fetched treatment: $id');
        return TreatmentModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch treatment: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in getTreatmentById: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in getTreatmentById: $e');
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.treatmentById(id)),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<TreatmentModel> createTreatment(
      CreateTreatmentRequestModel request,
      ) async {
    try {
      print('Creating new treatment for prescription: ${request.prescriptionId}');
      print('Request data: ${request.toJson()}');

      final response = await _dio.post(
        ApiEndpoints.treatments,
        data: request.toJson(),
      );

      print('Create treatment response status: ${response.statusCode}');
      print('Create treatment response data: ${response.data}');

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
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Unexpected error in createTreatment: $e');
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.treatments),
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

      print('Update request data: $requestData');

      final response = await _dio.put(
        ApiEndpoints.treatmentById(id),
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
        requestOptions: RequestOptions(path: ApiEndpoints.treatmentById(id)),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<void> deleteTreatment(String id) async {
    try {
      print('Deleting treatment: $id');
      final response = await _dio.delete(ApiEndpoints.treatmentById(id));

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
        requestOptions: RequestOptions(path: ApiEndpoints.treatmentById(id)),
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}