import 'package:flutter_mobile/domain/entities/prescription/reminder_time_entity.dart';

class CreateReminderEntity {
  const CreateReminderEntity({
    required this.treatmentId,
    required this.reminderTimes,
    required this.customMessage,
    required this.startPreference,
  });

  final String treatmentId;
  final List<ReminderTimeEntity> reminderTimes;
  final String customMessage;
  final String startPreference; // START_NEXT_CYCLE, START_NOW, etc.

  // Validation methods
  bool get isValid {
    return treatmentId.trim().isNotEmpty &&
        reminderTimes.isNotEmpty &&
        reminderTimes.every((time) => time.isValidTime) &&
        customMessage.trim().isNotEmpty &&
        startPreference.trim().isNotEmpty;
  }

  // Helper methods
  List<String> get uniqueTimeSlots {
    return reminderTimes.map((time) => time.timeSlot).toSet().toList();
  }

  int get remindersPerDay => reminderTimes.length;

  bool get hasMultipleTimeSlots => uniqueTimeSlots.length > 1;

  String get startPreferenceDisplayName {
    switch (startPreference.toUpperCase()) {
      case 'START_NEXT_CYCLE':
        return 'Commencer au prochain cycle';
      case 'START_NOW':
        return 'Commencer maintenant';
      case 'START_TOMORROW':
        return 'Commencer demain';
      default:
        return startPreference;
    }
  }

  // Get reminders sorted by time
  List<ReminderTimeEntity> get sortedReminderTimes {
    final sorted = List<ReminderTimeEntity>.from(reminderTimes);
    sorted.sort((a, b) => a.toDateTime().compareTo(b.toDateTime()));
    return sorted;
  }

  // Get reminder times grouped by time slot
  Map<String, List<ReminderTimeEntity>> get reminderTimesBySlot {
    final Map<String, List<ReminderTimeEntity>> grouped = {};
    for (final reminderTime in reminderTimes) {
      if (!grouped.containsKey(reminderTime.timeSlot)) {
        grouped[reminderTime.timeSlot] = [];
      }
      grouped[reminderTime.timeSlot]!.add(reminderTime);
    }
    return grouped;
  }

  // Helper method to create a copy with updated values
  CreateReminderEntity copyWith({
    String? treatmentId,
    List<ReminderTimeEntity>? reminderTimes,
    String? customMessage,
    String? startPreference,
  }) {
    return CreateReminderEntity(
      treatmentId: treatmentId ?? this.treatmentId,
      reminderTimes: reminderTimes ?? this.reminderTimes,
      customMessage: customMessage ?? this.customMessage,
      startPreference: startPreference ?? this.startPreference,
    );
  }

  // Helper method to get summary text
  String get reminderSummary {
    final timeSlotNames = uniqueTimeSlots.map((slot) {
      switch (slot.toUpperCase()) {
        case 'MORNING': return 'Matin';
        case 'AFTERNOON': return 'Après-midi';
        case 'EVENING': return 'Soir';
        case 'NIGHT': return 'Nuit';
        default: return slot;
      }
    }).join(', ');

    return '$remindersPerDay rappel(s) par jour: $timeSlotNames';
  }
}