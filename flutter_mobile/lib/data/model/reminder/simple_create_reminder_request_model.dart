import 'package:flutter_mobile/domain/entities/reminder/simple_create_reminder_entity.dart';

class SimpleCreateReminderRequestModel {
  const SimpleCreateReminderRequestModel({
    required this.treatmentId,
    required this.reminderTimes,
    required this.customMessage,
    required this.startPreference,
  });

  final String treatmentId;
  final List<Map<String, String>> reminderTimes;
  final String customMessage;
  final String startPreference;

  factory SimpleCreateReminderRequestModel.fromEntity(
    SimpleCreateReminderEntity entity,
  ) {
    return SimpleCreateReminderRequestModel(
      treatmentId: entity.treatmentId,
      reminderTimes: entity.reminderTimes
          .map((time) => {
                'timeSlot': time.timeSlot,
                'time': time.time,
              })
          .toList(),
      customMessage: entity.customMessage,
      startPreference: entity.startPreference,
    );
  }

  // Format 1: Standard camelCase
  Map<String, dynamic> toJson() => {
    'treatmentId': treatmentId,
    'reminderTimes': reminderTimes,
    'customMessage': customMessage,
    'startPreference': startPreference,
  };

  // Format 2: snake_case
  Map<String, dynamic> toJsonSnakeCase() => {
    'treatment_id': treatmentId,
    'reminder_times': reminderTimes,
    'custom_message': customMessage,
    'start_preference': startPreference,
  };

  // Format 3: simplified
  Map<String, dynamic> toJsonSimplified() => {
    'treatmentId': treatmentId,
    'times': reminderTimes,
    'message': customMessage,
  };

  // Format 4: minimal
  Map<String, dynamic> toJsonMinimal() => {
    'treatmentId': treatmentId,
    'reminderTimes': reminderTimes,
  };
}
