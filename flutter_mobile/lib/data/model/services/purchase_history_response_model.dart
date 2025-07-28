
import 'package:flutter_mobile/domain/entities/services/purchase_history_entity.dart';

class PurchaseHistoryResponseModel {

  PurchaseHistoryResponseModel({
    required this.id,
    required this.quantityPurchased,
    required this.expiryDate,
    this.createdAt,
    required this.myMedicineId,
    this.myMedicineName,
  });

  factory PurchaseHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseHistoryResponseModel(
      id: json['id'] as String,
      quantityPurchased: json['quantityPurchased'] as int,
      expiryDate: json['expiryDate'] as String,
      createdAt: json['createdAt'] as String?,
      myMedicineId: json['myMedicineId'] as String,
      myMedicineName: json['myMedicineName'] as String?,
    );
  }
  final String id;
  final int quantityPurchased;
  final String expiryDate;
  final String? createdAt;
  final String myMedicineId;
  final String? myMedicineName;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantityPurchased': quantityPurchased,
      'expiryDate': expiryDate,
      'createdAt': createdAt,
      'myMedicineId': myMedicineId,
      'myMedicineName': myMedicineName,
    };
  }

  PurchaseHistoryEntity toEntity() {
    return PurchaseHistoryEntity(
      id: id,
      myMedicineId: myMedicineId,
      quantityPurchased: quantityPurchased,
      expiryDate: DateTime.parse(expiryDate),
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      updatedAt: null, // Server doesn't provide updatedAt
    );
  }
}