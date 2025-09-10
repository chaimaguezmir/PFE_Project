class CreateTreatmentRequestModel {
  const CreateTreatmentRequestModel({
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

  Map<String, dynamic> toJson() => {
    'prescriptionId': prescriptionId,
    'myMedicineId': myMedicineId,
    'dosage': dosage,
    'frequency': frequency,
    'durationDays': durationDays,
  };

  factory CreateTreatmentRequestModel.fromJson(Map<String, dynamic> json) {
    return CreateTreatmentRequestModel(
      prescriptionId: json['prescriptionId'] as String,
      myMedicineId: json['myMedicineId'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      durationDays: json['durationDays'] as int,
    );
  }
}