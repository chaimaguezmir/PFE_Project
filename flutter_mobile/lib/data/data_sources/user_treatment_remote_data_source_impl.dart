import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/data/data_sources/user_treatment_remote_data_source.dart';
import 'package:flutter_mobile/data/model/prescription/treatment_model.dart';
import 'package:flutter_mobile/data/model/prescription/create_treatment_request_model.dart';

class UserTreatmentRemoteDataSourceImpl implements UserTreatmentRemoteDataSource {
  UserTreatmentRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<TreatmentModel>> getUserTreatments({
    required String groupId,
    required String userId,
  }) async {
    try {
      print('Fetching treatments for user: $userId in group: $groupId');

      final response = await _dio.get(
        ApiEndpoints.getUserTreatments(groupId, userId),
      );

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
      print('DioException in getUserTreatments: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in getUserTreatments: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: ApiEndpoints.getUserTreatments(groupId, userId),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<List<TreatmentModel>> getUserTreatmentsByPrescription({
    required String groupId,
    required String userId,
    required String prescriptionId,
  }) async {
    try {
      print('Fetching treatments for prescription: $prescriptionId');

      final response = await _dio.get(
        ApiEndpoints.getUserTreatmentsByPrescription(groupId, userId, prescriptionId),
      );

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
      print('DioException in getUserTreatmentsByPrescription: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in getUserTreatmentsByPrescription: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: ApiEndpoints.getUserTreatmentsByPrescription(groupId, userId, prescriptionId),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<TreatmentModel> getUserTreatmentById({
    required String groupId,
    required String userId,
    required String treatmentId,
  }) async {
    try {
      print('Fetching treatment $treatmentId for user: $userId');

      final response = await _dio.get(
        ApiEndpoints.getUserTreatmentById(groupId, userId, treatmentId),
      );

      if (response.statusCode == 200) {
        print('Successfully fetched treatment: $treatmentId');
        return TreatmentModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch treatment: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in getUserTreatmentById: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in getUserTreatmentById: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: ApiEndpoints.getUserTreatmentById(groupId, userId, treatmentId),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<TreatmentModel> createUserTreatment({
    required String groupId,
    required String userId,
    required CreateTreatmentRequestModel request,
  }) async {
    try {
      print('Creating treatment for user: $userId');

      final response = await _dio.post(
        ApiEndpoints.getUserTreatments(groupId, userId),
        data: request.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
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
      print('DioException in createUserTreatment: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in createUserTreatment: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: ApiEndpoints.getUserTreatments(groupId, userId),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<TreatmentModel> updateUserTreatment({
    required String groupId,
    required String userId,
    required String treatmentId,
    String? dosage,
    String? frequency,
    int? durationDays,
  }) async {
    try {
      print('Updating treatment $treatmentId for user: $userId');

      final Map<String, dynamic> data = {};
      if (dosage != null) data['dosage'] = dosage;
      if (frequency != null) data['frequency'] = frequency;
      if (durationDays != null) data['durationDays'] = durationDays;

      final response = await _dio.put(
        ApiEndpoints.getUserTreatmentById(groupId, userId, treatmentId),
        data: data,
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
      print('DioException in updateUserTreatment: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in updateUserTreatment: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: ApiEndpoints.getUserTreatmentById(groupId, userId, treatmentId),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<void> deleteUserTreatment({
    required String groupId,
    required String userId,
    required String treatmentId,
  }) async {
    try {
      print('Deleting treatment $treatmentId for user: $userId');

      final response = await _dio.delete(
        ApiEndpoints.getUserTreatmentById(groupId, userId, treatmentId),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Successfully deleted treatment');
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to delete treatment: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in deleteUserTreatment: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in deleteUserTreatment: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: ApiEndpoints.getUserTreatmentById(groupId, userId, treatmentId),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}