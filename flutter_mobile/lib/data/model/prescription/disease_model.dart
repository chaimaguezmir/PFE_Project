import 'package:flutter_mobile/domain/entities/prescription/disease_entity.dart';

class DiseaseModel extends DiseaseEntity {
  const DiseaseModel({
    required super.id,
    required super.name,
    required super.prescriptionCount,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      prescriptionCount: json['prescriptionCount'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'prescriptionCount': prescriptionCount,
  };
}