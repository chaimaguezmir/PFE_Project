import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/prescription/prescription_entity.dart';

abstract class PrescriptionRepository {
  Future<DataState<List<PrescriptionEntity>>> getPrescriptions();
  Future<DataState<PrescriptionEntity>> getPrescriptionById(String id);
  Future<DataState<PrescriptionEntity>> createPrescription({
    required String name,
    required DateTime startDate,
    DateTime? endDate,
    required List<String> diseaseIds,
  });
  Future<DataState<PrescriptionEntity>> updatePrescription({
    required String id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<DataState<void>> deletePrescription(String id);
}