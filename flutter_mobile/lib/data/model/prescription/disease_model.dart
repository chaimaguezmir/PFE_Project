// Defensive DiseaseModel with toEntity mapping
import 'package:flutter_mobile/domain/entities/prescription/disease_entity.dart';

class DiseaseModel {
  final String id;
  final String name;
  final int prescriptionCount;

  DiseaseModel({
    required this.id,
    required this.name,
    required this.prescriptionCount,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      prescriptionCount: _parseInt(json['prescriptionCount']),
    );
  }

  static int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'prescriptionCount': prescriptionCount,
  };

  // Convert model -> domain entity to avoid leaking data-layer types to presentation
  DiseaseEntity toEntity() {
    return DiseaseEntity(
      id: id,
      name: name,
      prescriptionCount: prescriptionCount,
    );
  }
}