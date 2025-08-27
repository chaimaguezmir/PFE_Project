import 'package:flutter_mobile/data/model/services/my_medicine_model.dart';
import 'package:flutter_mobile/domain/entities/prescription/treatment_entity.dart';

class TreatmentModel extends TreatmentEntity {
  const TreatmentModel({
    required super.id,
    required super.dosage,
    required super.frequency,
    required super.durationDays,
    required super.createdAt,
    required super.updatedAt,
    required super.prescriptionId,
    required super.prescriptionName,
    required super.myMedicine,
  });

  factory TreatmentModel.fromJson(Map<String, dynamic> json) {
    return TreatmentModel(
      id: json['id'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      durationDays: json['durationDays'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      prescriptionId: json['prescriptionId'] as String,
      prescriptionName: json['prescriptionName'] as String,
      myMedicine: MyMedicineModel.fromJson(json['myMedicine'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'dosage': dosage,
    'frequency': frequency,
    'durationDays': durationDays,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'prescriptionId': prescriptionId,
    'prescriptionName': prescriptionName,
    'myMedicine': (myMedicine as MyMedicineModel).toJson(),
  };
}