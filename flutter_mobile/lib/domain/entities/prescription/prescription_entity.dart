import 'package:flutter_mobile/domain/entities/prescription/disease_entity.dart';

class PrescriptionEntity {
  const PrescriptionEntity({
    required this.id,
    required this.name,
    required this.startDate,
    this.endDate, // FIXED: Made nullable
    required this.createdAt,
    required this.updatedAt,
    required this.diseases,
    required this.treatmentCount,
  });

  final String id;
  final String name;
  final DateTime startDate;
  final DateTime? endDate; // FIXED: Made nullable
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<DiseaseEntity> diseases;
  final int treatmentCount;

  // Helper getter for duration calculation - FIXED: Handle null endDate
  String get duration {
    if (endDate == null) {
      return 'Durée indéterminée';
    }
    final difference = endDate!.difference(startDate).inDays;
    if (difference <= 0) {
      return '1 jour';
    }
    return '$difference jours';
  }

  // Helper getter for status - FIXED: Handle null endDate
  bool get isActive {
    if (endDate == null) return true;
    return DateTime.now().isBefore(endDate!);
  }

  // Helper getter for primary disease name - FIXED: Handle empty diseases list
  String get primaryDiseaseName {
    if (diseases.isEmpty) return 'Non spécifié';
    final firstName = diseases.first.name;
    return firstName.isNotEmpty ? firstName : 'Non spécifié';
  }

  // FIXED: Add helper method for safe duration display
  String get safeDuration {
    try {
      return duration;
    } catch (e) {
      return 'Durée inconnue';
    }
  }

  // FIXED: Add helper method for safe status check
  bool get safeIsActive {
    try {
      return isActive;
    } catch (e) {
      return true; // Default to active if we can't determine
    }
  }
}