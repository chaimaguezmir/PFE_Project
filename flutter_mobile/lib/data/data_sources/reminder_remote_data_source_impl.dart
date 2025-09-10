// lib/data/data_sources/reminder_remote_datasource_impl.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/data/data_sources/reminder_remote_data_source.dart';
import 'package:flutter_mobile/data/model/prescription/reminder_model.dart';
import 'package:flutter_mobile/data/model/prescription/create_reminder_request_model.dart';

class ReminderRemoteDataSourceImpl implements ReminderRemoteDataSource {
  ReminderRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<ReminderModel>> getRemindersWithMedications() async {
    try {
      print('Fetching reminders with medications');
      final response = await _dio.get(ApiEndpoints.remindersWithMedications());

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
      print('DioException in getRemindersWithMedications: ${e.message}');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Unexpected error in getRemindersWithMedications: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: ApiEndpoints.remindersWithMedications(),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<List<ReminderModel>> getRemindersByTreatmentId(
    String treatmentId,
  ) async {
    try {
      print('Fetching reminders for treatment: $treatmentId');
      final response = await _dio.get(
        '${ApiEndpoints.reminders}/treatment/$treatmentId',
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        print('Successfully fetched ${data.length} reminders for treatment');
        return data.map((json) => ReminderModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch reminders: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in getRemindersByTreatmentId: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in getRemindersByTreatmentId: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: '${ApiEndpoints.reminders}/treatment/$treatmentId',
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<ReminderModel> getReminderById(String id) async {
    try {
      print('Fetching reminder by ID: $id');
      final response = await _dio.get(ApiEndpoints.reminderById(id));

      if (response.statusCode == 200) {
        print('Successfully fetched reminder: $id');
        return ReminderModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch reminder: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in getReminderById: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in getReminderById: $e');
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.reminderById(id)),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<List<ReminderModel>> createReminders(
    CreateReminderRequestModel request,
  ) async {
    try {
      print(
        '🔍 DEBUG: Creating reminders for treatment: ${request.treatmentId}',
      );

      // Debug the request data before sending
      final requestData = request.toJson();
      print('🔍 DEBUG: Full request data:');
      print('  treatmentId: ${requestData['treatmentId']}');
      print('  customMessage: ${requestData['customMessage']}');
      print('  startPreference: ${requestData['startPreference']}');
      print('  reminderTimes: ${requestData['reminderTimes']}');

      // Validate each reminderTime
      final reminderTimes = requestData['reminderTimes'] as List;
      print('🔍 DEBUG: Validating ${reminderTimes.length} reminder times:');
      for (int i = 0; i < reminderTimes.length; i++) {
        final rt = reminderTimes[i];
        print('  [$i] timeSlot: "${rt['timeSlot']}", time: "${rt['time']}"');

        // Check if time format is valid (HH:mm)
        final timeRegex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
        final isValidTime = timeRegex.hasMatch(rt['time']);
        print('    Time format valid: $isValidTime');

        // Check if timeSlot is valid
        final validTimeSlots = ['MORNING', 'AFTERNOON', 'EVENING', 'NIGHT'];
        final isValidTimeSlot = validTimeSlots.contains(rt['timeSlot']);
        print('    TimeSlot valid: $isValidTimeSlot');
      }

      final response = await _dio.post(
        ApiEndpoints.reminders,
        data: requestData,
      );

      print(
        '🔍 DEBUG: Create reminders response status: ${response.statusCode}',
      );
      print('🔍 DEBUG: Create reminders response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Successfully created reminders');
        final data = response.data as List;
        return data.map((json) => ReminderModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to create reminders: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('❌ DioException in createReminders: ${e.message}');
      print('   Status code: ${e.response?.statusCode}');
      print('   Response data: ${e.response?.data}');

      // Try to extract more specific error information
      if (e.response?.data != null) {
        try {
          final errorData = e.response!.data;
          if (errorData is Map) {
            print('   Error details:');
            errorData.forEach((key, value) {
              print('     $key: $value');
            });
          }
        } catch (parseError) {
          print('   Could not parse error response: $parseError');
        }
      }

      rethrow;
    } catch (e) {
      print('❌ Unexpected error in createReminders: $e');
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.reminders),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<ReminderModel> updateReminder({
    required String id,
    String? customMessage,
    DateTime? reminderTime,
    String? status,
  }) async {
    try {
      print('Updating reminder: $id');
      final requestData = <String, dynamic>{};

      if (customMessage != null) requestData['customMessage'] = customMessage;
      if (reminderTime != null)
        requestData['reminderTime'] = reminderTime.toIso8601String();
      if (status != null) requestData['status'] = status;

      print('Update request data: $requestData');

      final response = await _dio.put(
        ApiEndpoints.reminderById(id),
        data: requestData,
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
      print('DioException in updateReminder: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in updateReminder: $e');
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.reminderById(id)),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<void> deleteReminder(String id) async {
    try {
      print('Deleting reminder: $id');
      final response = await _dio.delete(ApiEndpoints.reminderById(id));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to delete reminder: ${response.statusMessage}',
        );
      }
      print('Successfully deleted reminder');
    } on DioException catch (e) {
      print('DioException in deleteReminder: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in deleteReminder: $e');
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.reminderById(id)),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<ReminderModel> markReminderAsTaken(String id) async {
    try {
      print('Marking reminder as taken: $id');
      final response = await _dio.put(
        '${ApiEndpoints.reminderById(id)}/take',
        data: {'status': 'TAKEN', 'takenAt': DateTime.now().toIso8601String()},
      );

      if (response.statusCode == 200) {
        print('Successfully marked reminder as taken');
        return ReminderModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message:
              'Failed to mark reminder as taken: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in markReminderAsTaken: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in markReminderAsTaken: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: '${ApiEndpoints.reminderById(id)}/take',
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<ReminderModel> snoozeReminder(
    String id,
    Duration snoozeDuration,
  ) async {
    try {
      print('Snoozing reminder: $id for ${snoozeDuration.inMinutes} minutes');
      final newReminderTime = DateTime.now().add(snoozeDuration);

      final response = await _dio.put(
        '${ApiEndpoints.reminderById(id)}/snooze',
        data: {
          'snoozedUntil': newReminderTime.toIso8601String(),
          'snoozeMinutes': snoozeDuration.inMinutes,
        },
      );

      if (response.statusCode == 200) {
        print('Successfully snoozed reminder');
        return ReminderModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to snooze reminder: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in snoozeReminder: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error in snoozeReminder: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: '${ApiEndpoints.reminderById(id)}/snooze',
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
