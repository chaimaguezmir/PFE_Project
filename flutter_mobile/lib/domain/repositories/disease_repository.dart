import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/prescription/disease_entity.dart';

abstract class DiseaseRepository {
  Future<DataState<List<DiseaseEntity>>> getDiseases();
}

