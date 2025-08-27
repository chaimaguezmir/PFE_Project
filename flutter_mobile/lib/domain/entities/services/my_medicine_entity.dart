import 'package:flutter_mobile/domain/entities/services/medicine_entity.dart';

class MyMedicineEntity {
  MyMedicineEntity({
    required this.id,
    required this.name,
    required this.form,
    required this.pharmacyBoxId,
    required this.pharmacyBoxName,
    this.medicine,
    this.customManufacturer,
    this.customDosageForm,
    this.customRequiresPrescription,
    required this.totalQuantityPurchased,
    required this.purchaseHistoryCount,
    required this.createdAt,
    required this.updatedAt,
    required this.customMedicine,
  });

  final String id;
  final String name;
  final String form;
  final String pharmacyBoxId;
  final String pharmacyBoxName;
  final MedicineEntity? medicine;
  final String? customManufacturer;
  final String? customDosageForm;
  final bool? customRequiresPrescription;
  final int totalQuantityPurchased;
  final int purchaseHistoryCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool customMedicine;

  // Helper getter for remaining quantity (same as totalQuantityPurchased)
  int get remainingQuantity => totalQuantityPurchased;

  // Helper getter for manufacturer
  String get manufacturerName => customMedicine
      ? (customManufacturer ?? 'Unknown')
      : (medicine?.manufacturer ?? 'Unknown');

  // Helper getter for dosage form
  String get dosageForm => customMedicine
      ? (customDosageForm ?? form)
      : (medicine?.dosageForm ?? form);
}