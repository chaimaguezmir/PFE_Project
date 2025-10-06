import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/data/data_sources/user_reminder_remote_data_source.dart';
import 'package:flutter_mobile/data/model/prescription/reminder_model.dart';

class UserReminderRemoteDataSourceImpl implements UserReminderRemoteDataSource {
  UserReminderRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<ReminderModel>> getUserRemindersWithMedications({
    required String groupId,
    required String userId,
  }) async {
    try {
      print('Fetching reminders with medications for user: $userId in group: $groupId');

      final response = await _dio.get(
        ApiEndpoints.getUserRemindersWithMedications(groupId, userId),
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        print('Successfully fetched ${data.length} reminders for user');
        return data.map((json) => ReminderModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch user reminders: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in getUserRemindersWithMedications: ${e.message}');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Unexpected error in getUserRemindersWithMedications: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: ApiEndpoints.getUserRemindersWithMedications(groupId, userId),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<List<ReminderModel>> getUserReminders({
    required String groupId,
    required String userId,
  }) async {
    try {
      print('Fetching reminders for user: $userId in group: $groupId');

      final response = await _dio.get(
        ApiEndpoints.getUserReminders(groupId, userId),
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        print('Successfully fetched ${data.length} reminders');
        return data.map((json) => ReminderModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch reminders: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in getUserReminders: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in getUserReminders: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: ApiEndpoints.getUserReminders(groupId, userId),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<ReminderModel> getUserReminderById({
    required String groupId,
    required String userId,
    required String reminderId,
  }) async {
    try {
      print('Fetching reminder $reminderId for user: $userId in group: $groupId');

      final response = await _dio.get(
        ApiEndpoints.getUserReminderById(groupId, userId, reminderId),
      );

      if (response.statusCode == 200) {
        print('Successfully fetched reminder: $reminderId');
        return ReminderModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch reminder: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in getUserReminderById: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in getUserReminderById: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: ApiEndpoints.getUserReminderById(groupId, userId, reminderId),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<ReminderModel> markUserReminderAsTaken({
    required String groupId,
    required String userId,
    required String reminderId,
  }) async {
    try {
      print('Marking reminder $reminderId as taken for user: $userId');

      final response = await _dio.patch(
        ApiEndpoints.markUserReminderAsTaken(groupId, userId, reminderId),
      );

      if (response.statusCode == 200) {
        print('Successfully marked reminder as taken');
        return ReminderModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to mark reminder as taken: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in markUserReminderAsTaken: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in markUserReminderAsTaken: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: ApiEndpoints.markUserReminderAsTaken(groupId, userId, reminderId),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<ReminderModel> updateUserReminder({
    required String groupId,
    required String userId,
    required String reminderId,
    String? customMessage,
    DateTime? reminderTime,
    String? status,
  }) async {
    try {
      print('Updating reminder $reminderId for user: $userId');

      final Map<String, dynamic> data = {};
      if (customMessage != null) data['customMessage'] = customMessage;
      if (reminderTime != null) data['reminderTime'] = reminderTime.toIso8601String();
      if (status != null) data['status'] = status;

      final response = await _dio.put(
        ApiEndpoints.updateUserReminder(groupId, userId, reminderId),
        data: data,
      );

      if (response.statusCode == 200) {
        print('Successfully updated reminder');
        return ReminderModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to update reminder: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in updateUserReminder: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in updateUserReminder: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: ApiEndpoints.updateUserReminder(groupId, userId, reminderId),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}