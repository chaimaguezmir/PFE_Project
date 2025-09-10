class ReminderTimeModel {
  const ReminderTimeModel({
    required this.timeSlot,
    required this.time,
  });

  final String timeSlot; // MORNING, AFTERNOON, EVENING, NIGHT
  final String time; // Format: "HH:mm"

  Map<String, dynamic> toJson() => {
    'timeSlot': timeSlot,
    'time': time,
  };

  factory ReminderTimeModel.fromJson(Map<String, dynamic> json) {
    return ReminderTimeModel(
      timeSlot: json['timeSlot'] as String,
      time: json['time'] as String,
    );
  }

  // Helper method to get display name for time slot
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
}