// lib/domain/entities/prescription/reminder_time_entity.dart
class ReminderTimeEntity {
  const ReminderTimeEntity({
    required this.timeSlot,
    required this.time,
  });

  final String timeSlot; // MORNING, NOON, EVENING, NIGHT
  final String time; // Format: "HH:mm"

  // Helper method to get display name for time slot
  String get timeSlotDisplayName {
    switch (timeSlot.toUpperCase()) {
      case 'MORNING':
        return 'Matin';
      case 'NOON':
        return 'Après-midi';
      case 'EVENING':
        return 'Soir';
      case 'NIGHT':
        return 'Nuit';
      default:
        return timeSlot;
    }
  }

  // Helper method to validate time format
  bool get isValidTime {
    final timeRegex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
    return timeRegex.hasMatch(time);
  }

  // Helper method to convert time string to DateTime (today)
  DateTime toDateTime() {
    final now = DateTime.now();
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  // Helper method to get time in 24-hour format
  String get time24Hour => time;

  // Helper method to get time in 12-hour format
  String get time12Hour {
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = timeParts[1];

    if (hour == 0) {
      return '12:$minute AM';
    } else if (hour < 12) {
      return '$hour:$minute AM';
    } else if (hour == 12) {
      return '12:$minute PM';
    } else {
      return '${hour - 12}:$minute PM';
    }
  }
}