class SimpleReminderEntity {
  const SimpleReminderEntity({
    required this.id,
    required this.treatmentId,
    required this.timeSlot,
    required this.time,
    required this.message,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String treatmentId;
  final String timeSlot;
  final String time;
  final String message;
  final String status;
  final DateTime createdAt;
}

