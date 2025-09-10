import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/reminder_entity.dart';

abstract class ReminderRepository {
  Future<DataState<List<ReminderEntity>>> getRemindersWithMedications();
  Future<DataState<List<ReminderEntity>>> getRemindersByTreatmentId(
    String treatmentId,
  );
  Future<DataState<ReminderEntity>> getReminderById(String id);

  // New methods for creating reminders
  Future<DataState<List<ReminderEntity>>> createReminders(
    CreateReminderEntity reminderRequest,
  );

  Future<DataState<ReminderEntity>> updateReminder({
    required String id,
    String? customMessage,
    DateTime? reminderTime,
    String? status,
  });

  Future<DataState<void>> deleteReminder(String id);

  // Mark reminder as taken/completed
  Future<DataState<ReminderEntity>> markReminderAsTaken(String id);

  // Snooze reminder
  Future<DataState<ReminderEntity>> snoozeReminder(
    String id,
    Duration snoozeDuration,
  );
}
