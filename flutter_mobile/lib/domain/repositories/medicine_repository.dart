import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/services/medicine_entity.dart';
import 'package:flutter_mobile/domain/entities/services/my_medicine_entity.dart';
import 'package:flutter_mobile/domain/entities/services/purchase_history_entity.dart';

abstract class MedicineRepository {
  Future<DataState<List<MyMedicineEntity>>> getMyMedicines(String pharmacyBoxId);
  Future<DataState<MedicineEntity>> getMedicineByBarcode(String barcode);

  // New methods
  Future<DataState<MyMedicineEntity?>> checkMyMedicine(String pharmacyBoxId, String medicineId);
  Future<DataState<MyMedicineEntity>> addMyMedicine({
    required String pharmacyBoxId,
    required String medicineId,
    required String name,
    required String form,
  });
  Future<DataState<PurchaseHistoryEntity>> addPurchaseHistory({
    required String myMedicineId,
    required int quantityPurchased,
    required DateTime expiryDate,
  });
}