import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/reminder/reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/reminder/simple_create_reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/reminder/simple_reminder_entity.dart';

abstract class UserReminderRepository {
  /// Get reminders with medications for a specific user in a group
  Future<DataState<List<ReminderEntity>>> getUserRemindersWithMedications({
    required String groupId,
    required String userId,
  });

  /// Get all reminders for a specific user in a group (without medication details)
  Future<DataState<List<ReminderEntity>>> getUserReminders({
    required String groupId,
    required String userId,
  });

  /// Create reminders for a user's treatment
  Future<DataState<List<SimpleReminderEntity>>> createUserReminders({
    required String groupId,
    required String userId,
    required SimpleCreateReminderEntity createReminderEntity,
  });

  /// Get specific user's reminder by ID
  Future<DataState<ReminderEntity>> getUserReminderById({
    required String groupId,
    required String userId,
    required String reminderId,
  });

  /// Mark user's reminder as taken (as caregiver/admin)
  Future<DataState<ReminderEntity>> markUserReminderAsTaken({
    required String groupId,
    required String userId,
    required String reminderId,
  });

  /// Update user's reminder
  Future<DataState<ReminderEntity>> updateUserReminder({
    required String groupId,
    required String userId,
    required String reminderId,
    String? customMessage,
    DateTime? reminderTime,
    String? status,
  });
}