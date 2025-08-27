import 'package:flutter_mobile/data/model/prescription/treatment_model.dart';

abstract class TreatmentRemoteDataSource {
  Future<List<TreatmentModel>> getTreatmentsByPrescriptionId(String prescriptionId);
  Future<TreatmentModel> createTreatment({
    required String prescriptionId,
    required String myMedicineId,
    required String dosage,
    required String frequency,
    required int durationDays,
  });
  Future<TreatmentModel> updateTreatment({
    required String id,
    String? dosage,
    String? frequency,
    int? durationDays,
  });
  Future<void> deleteTreatment(String id);
}