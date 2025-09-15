import 'package:flutter_mobile/domain/entities/reminder/simple_reminder_entity.dart';

class SimpleReminderResponseModel {
  factory SimpleReminderResponseModel.fromJson(Map<String, dynamic> json) {
    return SimpleReminderResponseModel(
      id: json['id'] as String? ?? '',
      treatmentId: json['treatmentId'] as String? ?? '',
      timeSlot: json['timeSlot'] as String? ?? '',
      time: json['time'] as String? ?? '',
      message:
          json['message'] as String? ?? json['customMessage'] as String? ?? '',
      status: json['status'] as String? ?? 'SCHEDULED',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
  const SimpleReminderResponseModel({
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

  SimpleReminderEntity toEntity() {
    return SimpleReminderEntity(
      id: id,
      treatmentId: treatmentId,
      timeSlot: timeSlot,
      time: time,
      message: message,
      status: status,
      createdAt: createdAt,
    );
  }
}
