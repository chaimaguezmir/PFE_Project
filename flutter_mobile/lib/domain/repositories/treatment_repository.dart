import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/prescription/treatment_entity.dart';


abstract class TreatmentRepository {
  Future<DataState<List<TreatmentEntity>>> getTreatmentsByPrescriptionId(String prescriptionId);
  Future<DataState<TreatmentEntity>> createTreatment({
    required String prescriptionId,
    required String myMedicineId,
    required String dosage,
    required String frequency,
    required int durationDays,
  });
  Future<DataState<TreatmentEntity>> updateTreatment({
    required String id,
    String? dosage,
    String? frequency,
    int? durationDays,
  });
  Future<DataState<void>> deleteTreatment(String id);
}
