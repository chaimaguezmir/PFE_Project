import 'package:flutter_mobile/data/model/prescription/create_treatment_request_model.dart';
import 'package:flutter_mobile/data/model/prescription/treatment_model.dart';

abstract class TreatmentRemoteDataSource {
  Future<List<TreatmentModel>> getTreatmentsByPrescriptionId(String prescriptionId);
  Future<TreatmentModel> getTreatmentById(String id);

  // New methods for creating treatments
  Future<TreatmentModel> createTreatment(
      CreateTreatmentRequestModel request,
      );

  Future<TreatmentModel> updateTreatment({
    required String id,
    String? dosage,
    String? frequency,
    int? durationDays,
  });

  Future<void> deleteTreatment(String id);
}