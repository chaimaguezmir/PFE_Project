import 'package:flutter_mobile/data/model/prescription/reminder_model.dart';
import 'package:flutter_mobile/data/model/reminder/simple_create_reminder_request_model.dart';
import 'package:flutter_mobile/data/model/reminder/simple_reminder_response_model.dart';

abstract class UserReminderRemoteDataSource {
  /// Get reminders with medications for a specific user in a group
  Future<List<ReminderModel>> getUserRemindersWithMedications({
    required String groupId,
    required String userId,
  });

  /// Get all reminders for a specific user in a group
  Future<List<ReminderModel>> getUserReminders({
    required String groupId,
    required String userId,
  });

  /// Create reminders for a user's treatment
  Future<List<SimpleReminderResponseModel>> createUserReminders({
    required String groupId,
    required String userId,
    required SimpleCreateReminderRequestModel request,
  });

  /// Get specific user's reminder by ID
  Future<ReminderModel> getUserReminderById({
    required String groupId,
    required String userId,
    required String reminderId,
  });

  /// Mark user's reminder as taken
  Future<ReminderModel> markUserReminderAsTaken({
    required String groupId,
    required String userId,
    required String reminderId,
  });

  /// Update user's reminder
  Future<ReminderModel> updateUserReminder({
    required String groupId,
    required String userId,
    required String reminderId,
    String? customMessage,
    DateTime? reminderTime,
    String? status,
  });
}