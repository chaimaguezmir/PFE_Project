import 'package:flutter_mobile/data/model/prescription/disease_model.dart';
import 'package:flutter_mobile/domain/entities/prescription/prescription_entity.dart';

class PrescriptionModel extends PrescriptionEntity {
  const PrescriptionModel({
    required super.id,
    required super.name,
    required super.startDate,
    super.endDate,
    required super.createdAt,
    required super.updatedAt,
    required super.diseases,
    required super.treatmentCount,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      diseases: (json['diseases'] as List)
          .map((disease) => DiseaseModel.fromJson(disease))
          .toList(),
      treatmentCount: json['treatmentCount'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'startDate': startDate.toIso8601String().split('T')[0],
    'endDate': endDate?.toIso8601String().split('T')[0],
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'diseases': diseases.map((disease) => (disease as DiseaseModel).toJson()).toList(),
    'treatmentCount': treatmentCount,
  };
}