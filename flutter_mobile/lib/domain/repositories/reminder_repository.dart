import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/reminder/reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/reminder/simple_create_reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/reminder/simple_reminder_entity.dart';

abstract class ReminderRepository {
  Future<DataState<List<ReminderEntity>>> getRemindersWithMedications();
  Future<DataState<List<ReminderEntity>>> getRemindersByTreatmentId(
    String treatmentId,
  );
  Future<DataState<ReminderEntity>> getReminderById(String id);

  Future<DataState<List<SimpleReminderEntity>>> createReminders(
      SimpleCreateReminderEntity reminderRequest,
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
