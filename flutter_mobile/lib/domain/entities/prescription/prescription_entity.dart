import 'package:flutter_mobile/domain/entities/prescription/disease_entity.dart';

class PrescriptionEntity {
  const PrescriptionEntity({
    required this.id,
    required this.name,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.diseases,
    required this.treatmentCount,
  });

  final String id;
  final String name;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<DiseaseEntity> diseases;
  final int treatmentCount;

  // Helper getter for duration calculation
  String get duration {
    if (endDate == null) {
      return 'Durée indéterminée';
    }
    final difference = endDate!.difference(startDate).inDays;
    return '$difference jours';
  }

  // Helper getter for status
  bool get isActive {
    if (endDate == null) return true;
    return DateTime.now().isBefore(endDate!);
  }

  // Helper getter for primary disease name
  String get primaryDiseaseName {
    return diseases.isNotEmpty ? diseases.first.name : 'Non spécifié';
  }
}