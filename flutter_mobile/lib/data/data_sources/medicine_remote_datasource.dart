import 'package:flutter_mobile/data/model/services/add_custom_my_medicine_request_model.dart';
import 'package:flutter_mobile/data/model/services/add_my_medicine_request_model.dart';
import 'package:flutter_mobile/data/model/services/add_purchase_history_request_model.dart';
import 'package:flutter_mobile/data/model/services/medicine_model.dart';
import 'package:flutter_mobile/data/model/services/my_medicine_model.dart';
import 'package:flutter_mobile/data/model/services/purchase_history_response_model.dart';

abstract class MedicineRemoteDataSource {
  //my medicines
  Future<List<MyMedicineModel>> getMyMedicines(String pharmacyBoxId);
  //medicine
  Future<MedicineModel> getMedicineByBarcode(String barcode);
  Future<MyMedicineModel?> checkMyMedicine(String pharmacyBoxId, String medicineId);
  Future<MyMedicineModel> addMyMedicine(AddMyMedicineRequestModel request);
  Future<PurchaseHistoryResponseModel> addPurchaseHistory(AddPurchaseHistoryRequestModel request);
  // New methods
  Future<List<MedicineModel>> getAllMedicines();
  Future<MyMedicineModel> addCustomMyMedicine(AddCustomMyMedicineRequestModel request);

}
