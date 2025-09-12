class SimpleReminderTimeEntity {
  const SimpleReminderTimeEntity({
    required this.timeSlot,
    required this.time,
  });

  final String timeSlot;
  final String time;

  // Clean the time string of any hidden characters
  String get cleanTime {
    return time.trim().replaceAll(RegExp(r'[^\d:]'), '');
  }

  // Clean the timeSlot string
  String get cleanTimeSlot {
    return timeSlot.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
  }

  bool get isValidTime {
    final cleanedTime = cleanTime;
    final timeRegex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
    final isValid = timeRegex.hasMatch(cleanedTime);

    if (!isValid) {
      print('Time validation failed:');
      print('  Original: "$time" (length: ${time.length})');
      print('  Cleaned: "$cleanedTime" (length: ${cleanedTime.length})');
      print('  Char codes: ${time.codeUnits}');
    }
    return isValid;
  }

  bool get isValidTimeSlot {
    const validSlots = ['MORNING', 'NOON', 'EVENING', 'NIGHT'];
    final cleanedSlot = cleanTimeSlot;
    final isValid = validSlots.contains(cleanedSlot);

    if (!isValid) {
      print('TimeSlot validation failed:');
      print('  Original: "$timeSlot"');
      print('  Cleaned: "$cleanedSlot"');
      print('  Valid options: $validSlots');
    }
    return isValid;
  }

  Map<String, dynamic> toJson() => {
    'timeSlot': cleanTimeSlot,
    'time': cleanTime,
  };
}
