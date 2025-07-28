import 'package:flutter_mobile/domain/entities/services/my_medicine_entity.dart';

class TreatmentEntity {
  const TreatmentEntity({
    required this.id,
    required this.dosage,
    required this.frequency,
    required this.durationDays,
    required this.createdAt,
    required this.updatedAt,
    required this.prescriptionId,
    required this.prescriptionName,
    required this.myMedicine,
  });

  final String id;
  final String dosage;
  final String frequency;
  final int durationDays;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String prescriptionId;
  final String prescriptionName;
  final MyMedicineEntity myMedicine;

  // Helper getters
  String get medicationName => myMedicine.name;
  String get duration => '$durationDays jours';
  String get instructions => '$dosage, $frequency';

  // Calculate progress based on creation date and duration
  int get progress {
    final now = DateTime.now();
    final daysPassed = now.difference(createdAt).inDays + 1;
    final progressPercentage = ((daysPassed / durationDays) * 100).clamp(0, 100);
    return progressPercentage.round();
  }

  bool get isCompleted => progress >= 100;

  String get manufacturerName => myMedicine.manufacturerName;
  String get dosageForm => myMedicine.dosageForm;
}