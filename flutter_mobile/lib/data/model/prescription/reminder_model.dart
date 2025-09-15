import 'package:flutter_mobile/domain/entities/reminder/reminder_entity.dart';

class ReminderModel extends ReminderEntity {
  const ReminderModel({
    required super.id,
    required super.myMedicineId,
    required super.medicationName,
    required super.prescriptionId,
    required super.prescriptionName,
    required super.reminderTime,
    required super.status,
    required super.message,
    required super.createdAt,
    required super.updatedAt,
    required super.treatmentId,
    required super.timeSlot,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'] as String,
      myMedicineId: json['myMedicineId'] as String,
      medicationName: json['medicationName'] as String,
      prescriptionId: json['prescriptionId'] as String,
      prescriptionName: json['prescriptionName'] as String,
      reminderTime: DateTime.parse(json['reminderTime'] as String),
      status: json['status'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      treatmentId: json['treatmentId'] as String,
      timeSlot: json['timeSlot'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'myMedicineId': myMedicineId,
        'medicationName': medicationName,
        'prescriptionId': prescriptionId,
        'prescriptionName': prescriptionName,
        'reminderTime': reminderTime.toIso8601String(),
        'status': status,
        'message': message,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'treatmentId': treatmentId,
        'timeSlot': timeSlot,
      };
}

