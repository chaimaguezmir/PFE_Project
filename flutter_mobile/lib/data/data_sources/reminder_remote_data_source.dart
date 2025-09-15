import 'package:flutter_mobile/data/model/prescription/create_reminder_request_model.dart';
import 'package:flutter_mobile/data/model/prescription/reminder_model.dart';
import 'package:flutter_mobile/data/model/reminder/simple_create_reminder_request_model.dart';
import 'package:flutter_mobile/data/model/reminder/simple_reminder_response_model.dart';

abstract class ReminderRemoteDataSource {
  Future<List<ReminderModel>> getRemindersWithMedications();
  Future<List<ReminderModel>> getRemindersByTreatmentId(String treatmentId);
  Future<ReminderModel> getReminderById(String id);

  Future<List<SimpleReminderResponseModel>> createReminders(
      SimpleCreateReminderRequestModel request,
      );

  Future<ReminderModel> updateReminder({
    required String id,
    String? customMessage,
    DateTime? reminderTime,
    String? status,
  });

  Future<void> deleteReminder(String id);

  // Mark reminder as taken/completed
  Future<ReminderModel> markReminderAsTaken(String id);

  // Snooze reminder
  Future<ReminderModel> snoozeReminder(String id, Duration snoozeDuration);
}