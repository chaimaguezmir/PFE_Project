class AddPurchaseHistoryRequestModel {
  AddPurchaseHistoryRequestModel({
    required this.myMedicineId,
    required this.quantityPurchased,
    required this.expiryDate,
  });

  final String myMedicineId;
  final int quantityPurchased;
  final String expiryDate; // Format: "YYYY-MM-DD"

  Map<String, dynamic> toJson() => {
    'myMedicineId': myMedicineId,
    'quantityPurchased': quantityPurchased,
    'expiryDate': expiryDate,
  };
}