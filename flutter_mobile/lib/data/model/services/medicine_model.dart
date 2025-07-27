

import 'package:flutter_mobile/domain/entities/services/medicine_entity.dart';

class MedicineModel extends MedicineEntity {
  MedicineModel({
    required super.id,
    required super.name,
    required super.manufacturer,
    required super.dosageForm,
    required super.requiresPrescription,
    required super.barcode,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'] as String,
      name: json['name'] as String,
      manufacturer: json['manufacturer'] as String,
      dosageForm: json['dosageForm'] as String,
      requiresPrescription: json['requiresPrescription'] as bool,
      barcode: json['barcode'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'manufacturer': manufacturer,
    'dosageForm': dosageForm,
    'requiresPrescription': requiresPrescription,
    'barcode': barcode,
  };
}