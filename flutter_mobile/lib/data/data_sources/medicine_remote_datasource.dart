import 'package:flutter_mobile/data/model/services/add_custom_my_medicine_request_model.dart';
import 'package:flutter_mobile/data/model/services/add_my_medicine_request_model.dart';
import 'package:flutter_mobile/data/model/services/add_purchase_history_request_model.dart';
import 'package:flutter_mobile/data/model/services/medicine_model.dart';
import 'package:flutter_mobile/data/model/services/my_medicine_model.dart';
import 'package:flutter_mobile/data/model/services/purchase_history_response_model.dart';

abstract class MedicineRemoteDataSource {
  Future<List<MyMedicineModel>> getMyMedicines(String pharmacyBoxId);
  Future<MedicineModel> getMedicineByBarcode(String barcode);
  Future<MyMedicineModel?> checkMyMedicine(String pharmacyBoxId, String medicineId);
  Future<MyMedicineModel> addMyMedicine(AddMyMedicineRequestModel request);
  Future<PurchaseHistoryResponseModel> addPurchaseHistory(AddPurchaseHistoryRequestModel request);
  Future<List<MedicineModel>> getAllMedicines();
  Future<MyMedicineModel> addCustomMyMedicine(AddCustomMyMedicineRequestModel request);

  // New search method
  Future<List<MedicineModel>> searchMedicinesByName(String query);

  // New barcode removal method
  Future<void> removeBarcode({
    required String medicineId,
    required String barcode,
  });
  Future<void> assignBarcode({
    required String medicineId,
    required String barcode,
  });

  // Get purchase history for a specific medicine
  Future<List<PurchaseHistoryResponseModel>> getPurchaseHistory(String myMedicineId);

  // Update purchase history
  Future<PurchaseHistoryResponseModel> updatePurchaseHistory({
    required String purchaseHistoryId,
    required int quantityPurchased,
    required DateTime expiryDate,
  });

  // Delete purchase history
  Future<void> deletePurchaseHistory(String purchaseHistoryId);
}