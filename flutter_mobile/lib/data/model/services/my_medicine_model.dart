

import 'package:flutter_mobile/data/model/services/medicine_model.dart';
import 'package:flutter_mobile/domain/entities/services/my_medicine_entity.dart';

class MyMedicineModel extends MyMedicineEntity {
  MyMedicineModel({
    required super.id,
    required super.name,
    required super.form,
    required super.pharmacyBoxId,
    required super.pharmacyBoxName,
    super.medicine,
    super.customManufacturer,
    super.customDosageForm,
    super.customRequiresPrescription,
    required super.totalQuantityPurchased,
    required super.purchaseHistoryCount,
    required super.createdAt,
    required super.updatedAt,
    required super.customMedicine,
  });

  factory MyMedicineModel.fromJson(Map<String, dynamic> json) {
    return MyMedicineModel(
      id: json['id'] as String,
      name: json['name'] as String,
      form: json['form'] as String,
      pharmacyBoxId: json['pharmacyBoxId'] as String,
      pharmacyBoxName: json['pharmacyBoxName'] as String,
      medicine: json['medicine'] != null
          ? MedicineModel.fromJson(json['medicine'])
          : null,
      customManufacturer: json['customManufacturer'] as String?,
      customDosageForm: json['customDosageForm'] as String?,
      customRequiresPrescription: json['customRequiresPrescription'] as bool?,
      totalQuantityPurchased: json['totalQuantityPurchased'] as int,
      purchaseHistoryCount: json['purchaseHistoryCount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      customMedicine: json['customMedicine'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'form': form,
    'pharmacyBoxId': pharmacyBoxId,
    'pharmacyBoxName': pharmacyBoxName,
    'medicine': medicine != null ? (medicine as MedicineModel).toJson() : null,
    'customManufacturer': customManufacturer,
    'customDosageForm': customDosageForm,
    'customRequiresPrescription': customRequiresPrescription,
    'totalQuantityPurchased': totalQuantityPurchased,
    'purchaseHistoryCount': purchaseHistoryCount,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'customMedicine': customMedicine,
  };
}
