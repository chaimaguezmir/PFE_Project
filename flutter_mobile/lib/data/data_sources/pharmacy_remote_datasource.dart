
import 'package:flutter_mobile/data/model/services/pharmacy_box_model.dart';

abstract class PharmacyRemoteDataSource {
  Future<List<PharmacyBoxModel>> getMyPharmacyBoxes();
}
