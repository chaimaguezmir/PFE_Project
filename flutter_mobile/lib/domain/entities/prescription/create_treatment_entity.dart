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
  final String dosage;
  final String frequency;
  final int durationDays;

  // Validation methods
  bool get isValid =>
      prescriptionId.trim().isNotEmpty &&
          myMedicineId.trim().isNotEmpty &&
          dosage.trim().isNotEmpty &&
          frequency.trim().isNotEmpty &&
          durationDays > 0;

  bool get isShortTerm => durationDays <= 7;
  bool get isMediumTerm => durationDays > 7 && durationDays <= 30;
  bool get isLongTerm => durationDays > 30;

  String get durationDescription {
    if (durationDays == 1) return '1 jour';
    if (durationDays < 7) return '$durationDays jours';
    if (durationDays == 7) return '1 semaine';
    if (durationDays < 30) return '${(durationDays / 7).ceil()} semaines';
    if (durationDays == 30) return '1 mois';
    return '${(durationDays / 30).ceil()} mois';
  }

  String get treatmentSummary => '$dosage, $frequency pendant $durationDescription';

  // Helper method to create a copy with updated values
  CreateTreatmentEntity copyWith({
    String? prescriptionId,
    String? myMedicineId,
    String? dosage,
    String? frequency,
    int? durationDays,
  }) {
    return CreateTreatmentEntity(
      prescriptionId: prescriptionId ?? this.prescriptionId,
      myMedicineId: myMedicineId ?? this.myMedicineId,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      durationDays: durationDays ?? this.durationDays,
    );
  }
}