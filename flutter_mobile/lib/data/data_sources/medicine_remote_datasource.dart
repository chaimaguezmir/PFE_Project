import 'package:flutter_mobile/data/model/services/medicine_model.dart';
import 'package:flutter_mobile/data/model/services/my_medicine_model.dart';

abstract class MedicineRemoteDataSource {
  //my medicines
  Future<List<MyMedicineModel>> getMyMedicines(String pharmacyBoxId);
  //medicine
  Future<MedicineModel> getMedicineByBarcode(String barcode);
}
