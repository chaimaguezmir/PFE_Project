import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/services/medicine_entity.dart';
import 'package:flutter_mobile/domain/entities/services/my_medicine_entity.dart';

abstract class MedicineRepository {
  Future<DataState<List<MyMedicineEntity>>> getMyMedicines(String pharmacyBoxId);
  Future<DataState<MedicineEntity>> getMedicineByBarcode(String barcode);
}