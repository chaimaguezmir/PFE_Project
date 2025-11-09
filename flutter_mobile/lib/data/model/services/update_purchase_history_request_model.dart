class UpdatePurchaseHistoryRequestModel {
  UpdatePurchaseHistoryRequestModel({
    required this.quantityPurchased,
    required this.expiryDate,
  });

  final int quantityPurchased;
  final String expiryDate;

  Map<String, dynamic> toJson() {
    return {
      'quantityPurchased': quantityPurchased,
      'expiryDate': expiryDate,
    };
  }
}
