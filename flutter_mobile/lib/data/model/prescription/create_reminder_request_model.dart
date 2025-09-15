import 'package:flutter_mobile/data/model/prescription/reminder_time_model.dart';

class CreateReminderRequestModel {
  const CreateReminderRequestModel({
    required this.treatmentId,
    required this.reminderTimes,
    required this.customMessage,
    required this.startPreference,
  });

  final String treatmentId;
  final List<ReminderTimeModel> reminderTimes;
  final String customMessage;
  final String startPreference; // START_NEXT_CYCLE, START_NOW, etc.

  Map<String, dynamic> toJson() => {
    'treatmentId': treatmentId,
    'reminderTimes': reminderTimes.map((time) => time.toJson()).toList(),
    'customMessage': customMessage,
    'startPreference': startPreference,
  };

  factory CreateReminderRequestModel.fromJson(Map<String, dynamic> json) {
    return CreateReminderRequestModel(
      treatmentId: json['treatmentId'] as String,
      reminderTimes: (json['reminderTimes'] as List<dynamic>)
          .map((time) => ReminderTimeModel.fromJson(time as Map<String, dynamic>))
          .toList(),
      customMessage: json['customMessage'] as String,
      startPreference: json['startPreference'] as String,
    );
  }

  // Helper method to validate the request
  bool get isValid {
    return treatmentId.isNotEmpty &&
        reminderTimes.isNotEmpty &&
        reminderTimes.every((time) => time.isValidTime) &&
        customMessage.isNotEmpty &&
        startPreference.isNotEmpty;
  }

  // Helper method to get unique time slots
  List<String> get uniqueTimeSlots {
    return reminderTimes.map((time) => time.timeSlot).toSet().toList();
  }

  // Helper method to count reminders per day
  int get remindersPerDay => reminderTimes.length;
}