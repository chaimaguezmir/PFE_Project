import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/data/data_sources/user_prescription_remote_data_source.dart';
import 'package:flutter_mobile/data/model/prescription/prescription_model.dart';
import 'package:flutter_mobile/data/model/prescription/create_prescription_request_model.dart';

class UserPrescriptionRemoteDataSourceImpl implements UserPrescriptionRemoteDataSource {
  UserPrescriptionRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<PrescriptionModel>> getUserPrescriptions({
    required String groupId,
    required String userId,
  }) async {
    try {
      print('Fetching prescriptions for user: $userId in group: $groupId');

      final response = await _dio.get(
        ApiEndpoints.getUserPrescriptions(groupId, userId),
      );

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
      print('DioException in getUserPrescriptions: ${e.message}');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Unexpected error in getUserPrescriptions: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: ApiEndpoints.getUserPrescriptions(groupId, userId),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<PrescriptionModel> getUserPrescriptionById({
    required String groupId,
    required String userId,
    required String prescriptionId,
  }) async {
    try {
      print('Fetching prescription $prescriptionId for user: $userId');

      final response = await _dio.get(
        ApiEndpoints.getUserPrescriptionById(groupId, userId, prescriptionId),
      );

      if (response.statusCode == 200) {
        print('Successfully fetched prescription: $prescriptionId');
        return PrescriptionModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch prescription: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in getUserPrescriptionById: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in getUserPrescriptionById: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: ApiEndpoints.getUserPrescriptionById(groupId, userId, prescriptionId),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<PrescriptionModel> createUserPrescription({
    required String groupId,
    required String userId,
    required CreatePrescriptionRequestModel request,
  }) async {
    try {
      print('Creating prescription for user: $userId in group: $groupId');

      final response = await _dio.post(
        ApiEndpoints.getUserPrescriptions(groupId, userId),
        data: request.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
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
      print('DioException in createUserPrescription: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in createUserPrescription: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: ApiEndpoints.getUserPrescriptions(groupId, userId),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<PrescriptionModel> updateUserPrescription({
    required String groupId,
    required String userId,
    required String prescriptionId,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      print('Updating prescription $prescriptionId for user: $userId');

      final Map<String, dynamic> data = {};
      if (name != null) data['name'] = name;
      if (startDate != null) data['startDate'] = startDate.toIso8601String();
      if (endDate != null) data['endDate'] = endDate.toIso8601String();

      final response = await _dio.put(
        ApiEndpoints.getUserPrescriptionById(groupId, userId, prescriptionId),
        data: data,
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
      print('DioException in updateUserPrescription: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in updateUserPrescription: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: ApiEndpoints.getUserPrescriptionById(groupId, userId, prescriptionId),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<void> deleteUserPrescription({
    required String groupId,
    required String userId,
    required String prescriptionId,
  }) async {
    try {
      print('Deleting prescription $prescriptionId for user: $userId');

      final response = await _dio.delete(
        ApiEndpoints.getUserPrescriptionById(groupId, userId, prescriptionId),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Successfully deleted prescription');
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to delete prescription: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in deleteUserPrescription: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in deleteUserPrescription: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: ApiEndpoints.getUserPrescriptionById(groupId, userId, prescriptionId),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}