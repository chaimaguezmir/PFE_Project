import 'package:flutter_mobile/domain/entities/services/medicine_entity.dart';

class MedicineModel extends MedicineEntity {
  MedicineModel({
    required super.id,
    required super.name,
    required super.manufacturer,
    required super.dosageForm,
    required super.requiresPrescription,
    required super.barcode,
    super.designation,
    super.dosage,
    super.form,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'] as String,
      name: json['name'] as String,
      manufacturer: json['manufacturer'] as String,
      // Use 'form' field as dosageForm for backward compatibility
      dosageForm: json['form'] as String? ?? json['dosageForm'] as String? ?? '',
      requiresPrescription: json['requiresPrescription'] as bool,
      barcode: json['barcode'] as String,
      // New fields
      designation: json['designation'] as String?,
      dosage: json['dosage'] as String?,
      form: json['form'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'manufacturer': manufacturer,
    'dosageForm': dosageForm,
    'requiresPrescription': requiresPrescription,
    'barcode': barcode,
    if (designation != null) 'designation': designation,
    if (dosage != null) 'dosage': dosage,
    if (form != null) 'form': form,
  };
}