class ReminderEntity {
  final String id;
  final String myMedicineId;
  final String medicationName;
  final String prescriptionId;
  final String prescriptionName;
  final DateTime reminderTime;
  final String status;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String treatmentId;
  final String timeSlot;

  const ReminderEntity({
    required this.id,
    required this.myMedicineId,
    required this.medicationName,
    required this.prescriptionId,
    required this.prescriptionName,
    required this.reminderTime,
    required this.status,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.treatmentId,
    required this.timeSlot,
  });
}

