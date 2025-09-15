
import 'package:flutter_mobile/domain/entities/services/medicine_entity.dart';

class MedicineModel extends MedicineEntity {
  MedicineModel({
    required super.id,
    required super.medicationName,
    required super.dosage,
    required super.form,
    required super.presentation,
    required super.dci,
    required super.therapeuticClass,
    required super.subClass,
    required super.laboratory,
    required super.ammNumber,
    required super.ammDate,
    required super.primaryPackaging,
    required super.packagingSpecification,
    required super.scheduleCategory,
    required super.shelfLife,
    required super.indications,
    required super.medicationType,
    required super.veicClassification,
    required super.barcode,
    required super.requiresPrescription,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    try {
      // Debug the incoming JSON
      print('🏥 Parsing medicine JSON: ${json['medicationName']}');

      return MedicineModel(
        id: json['id'] as String? ?? '',
        medicationName: json['medicationName'] as String? ?? '',
        dosage: json['dosage'] as String? ?? '',
        form: json['form'] as String? ?? '',
        presentation: json['presentation'] as String? ?? '',
        dci: json['dci'] as String? ?? '',
        therapeuticClass: json['therapeuticClass'] as String? ?? '',
        subClass: json['subClass'] as String? ?? '',
        laboratory: json['laboratory'] as String? ?? '',
        ammNumber: json['ammNumber'] as String? ?? '',
        ammDate: json['ammDate'] as String? ?? '',
        primaryPackaging: json['primaryPackaging'] as String? ?? '',
        packagingSpecification: json['packagingSpecification'] as String? ?? '',
        scheduleCategory: json['scheduleCategory'] as String? ?? '',
        shelfLife: json['shelfLife'] as String? ?? '',
        indications: json['indications'] as String? ?? '',
        medicationType: json['medicationType'] as String? ?? '',
        veicClassification: json['veicClassification'] as String? ?? '',
        // Handle null barcode safely
        barcode: json['barcode'] as String? ?? '',
        requiresPrescription: json['requiresPrescription'] as bool? ?? false,
      );
    } catch (e, stackTrace) {
      print('🏥 Error parsing medicine JSON: $json');
      print('🏥 Error: $e');
      print('🏥 Stack trace: $stackTrace');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'medicationName': medicationName,
    'dosage': dosage,
    'form': form,
    'presentation': presentation,
    'dci': dci,
    'therapeuticClass': therapeuticClass,
    'subClass': subClass,
    'laboratory': laboratory,
    'ammNumber': ammNumber,
    'ammDate': ammDate,
    'primaryPackaging': primaryPackaging,
    'packagingSpecification': packagingSpecification,
    'scheduleCategory': scheduleCategory,
    'shelfLife': shelfLife,
    'indications': indications,
    'medicationType': medicationType,
    'veicClassification': veicClassification,
    // Convert empty string back to null for API consistency
    'barcode': barcode.isEmpty ? null : barcode,
    'requiresPrescription': requiresPrescription,
  };
}