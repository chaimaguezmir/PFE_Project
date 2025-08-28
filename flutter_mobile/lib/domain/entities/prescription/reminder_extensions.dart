// lib/domain/entities/prescription/reminder_extensions.dart
import 'package:flutter_mobile/domain/entities/prescription/reminder_entity.dart';

extension ReminderEntityExtensions on ReminderEntity {

  /// Returns a copy of this reminder with updated fields
  ReminderEntity copyWith({
    String? id,
    String? myMedicineId,
    String? medicationName,
    String? prescriptionId,
    String? prescriptionName,
    DateTime? reminderTime,
    String? status,
    String? message,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? treatmentId,
    String? timeSlot,
  }) {
    return ReminderEntity(
      id: id ?? this.id,
      myMedicineId: myMedicineId ?? this.myMedicineId,
      medicationName: medicationName ?? this.medicationName,
      prescriptionId: prescriptionId ?? this.prescriptionId,
      prescriptionName: prescriptionName ?? this.prescriptionName,
      reminderTime: reminderTime ?? this.reminderTime,
      status: status ?? this.status,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      treatmentId: treatmentId ?? this.treatmentId,
      timeSlot: timeSlot ?? this.timeSlot,
    );
  }

  /// Check if the reminder is for today
  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final reminderDate = DateTime(
      reminderTime.year,
      reminderTime.month,
      reminderTime.day,
    );
    return reminderDate.isAtSameMomentAs(today);
  }

  /// Check if the reminder is overdue
  bool get isOverdue {
    final now = DateTime.now();
    return reminderTime.isBefore(now) && status.toUpperCase() == 'SCHEDULED';
  }

  /// Check if the reminder is due now (within 30 minutes)
  bool get isDue {
    final now = DateTime.now();
    final timeDifference = reminderTime.difference(now).inMinutes.abs();
    return timeDifference <= 30 && status.toUpperCase() == 'SCHEDULED';
  }

  /// Check if medication has been taken
  bool get isTaken => status.toUpperCase() == 'TAKEN';

  /// Check if reminder is scheduled
  bool get isScheduled => status.toUpperCase() == 'SCHEDULED';

  /// Get formatted time string (HH:mm)
  String get timeString {
    return '${reminderTime.hour.toString().padLeft(2, '0')}:${reminderTime.minute.toString().padLeft(2, '0')}';
  }

  /// Get display name for time slot
  String get timeSlotDisplayName {
    switch (timeSlot.toUpperCase()) {
      case 'MORNING':
        return 'Matin';
      case 'AFTERNOON':
        return 'Après-midi';
      case 'EVENING':
        return 'Soir';
      case 'NIGHT':
        return 'Nuit';
      default:
        return timeSlot;
    }
  }

  /// Get normalized time slot for grouping
  String get normalizedTimeSlot {
    switch (timeSlot.toUpperCase()) {
      case 'MATIN':
        return 'MORNING';
      case 'APRES_MIDI':
      case 'APRÈS_MIDI':
        return 'AFTERNOON';
      case 'SOIR':
        return 'EVENING';
      case 'NUIT':
        return 'NIGHT';
      default:
        return timeSlot.toUpperCase();
    }
  }
}