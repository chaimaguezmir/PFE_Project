class CreateTreatmentEntity {
  const CreateTreatmentEntity({
    required this.prescriptionId,
    required this.myMedicineId,
    required this.dosage,
    required this.frequency,
    required this.durationDays,
  });

  final String prescriptionId;
  final String myMedicineId;
  final String dosage; // API expects string "1"
  final String frequency;
  final int durationDays;

  Map<String, dynamic> toJson() => {
    'prescriptionId': prescriptionId,
    'myMedicineId': myMedicineId,
    'dosage': dosage,
    'frequency': frequency,
    'durationDays': durationDays,
  };
}