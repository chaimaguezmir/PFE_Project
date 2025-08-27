class PurchaseHistoryEntity {
  PurchaseHistoryEntity({
    required this.id,
    required this.myMedicineId,
    required this.quantityPurchased,
    required this.expiryDate,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String myMedicineId;
  final int quantityPurchased;
  final DateTime expiryDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}