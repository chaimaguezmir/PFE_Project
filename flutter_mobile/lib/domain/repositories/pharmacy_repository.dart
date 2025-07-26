import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/services/PharmacyBoxEntity.dart';

abstract class PharmacyRepository {
  Future<DataState<List<PharmacyBoxEntity>>> getMyPharmacyBoxes();
}