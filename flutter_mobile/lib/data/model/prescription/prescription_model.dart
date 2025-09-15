// PrescriptionModel with defensive parsing and toEntity mapping
import 'package:flutter_mobile/data/model/prescription/disease_model.dart';
import 'package:flutter_mobile/domain/entities/prescription/prescription_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/disease_entity.dart';

class PrescriptionModel {
  final String id;
  final String name;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<DiseaseModel> diseases;
  final int treatmentCount;

  PrescriptionModel({
    required this.id,
    required this.name,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    required this.diseases,
    required this.treatmentCount,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    final diseasesJson = json['diseases'];
    List<DiseaseModel> diseasesList = [];
    if (diseasesJson is List) {
      diseasesList = diseasesJson
          .where((e) => e != null)
          .map((e) {
        try {
          return DiseaseModel.fromJson(Map<String, dynamic>.from(e));
        } catch (_) {
          // tolerate unexpected disease item shapes
          return DiseaseModel(id: '', name: '', prescriptionCount: 0);
        }
      })
          .toList();
    }

    return PrescriptionModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      startDate: _parseDate(json['startDate']),
      endDate: _parseDate(json['endDate']),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      diseases: diseasesList,
      treatmentCount: _parseInt(json['treatmentCount']),
    );
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    try {
      return DateTime.parse(v.toString());
    } catch (_) {
      return null;
    }
  }

  static int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'startDate': startDate?.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'diseases': diseases.map((d) => d.toJson()).toList(),
    'treatmentCount': treatmentCount,
  };

  // FIXED: Convert model -> domain entity with proper null safety
  PrescriptionEntity toEntity() {
    // Provide safe defaults for required fields
    final safeStartDate = startDate ?? createdAt ?? DateTime.now();
    final safeEndDate = endDate; // This can remain nullable in entity
    final safeCreatedAt = createdAt ?? DateTime.now();
    final safeUpdatedAt = updatedAt ?? createdAt ?? DateTime.now();

    return PrescriptionEntity(
      id: id,
      name: name.isNotEmpty ? name : 'Prescription sans nom',
      startDate: safeStartDate,
      endDate: safeEndDate,
      createdAt: safeCreatedAt,
      updatedAt: safeUpdatedAt,
      diseases: diseases.map((d) => d.toEntity()).toList(),
      treatmentCount: treatmentCount,
    );
  }
}