import 'package:flutter_mobile/data/model/prescription/create_prescription_request_model.dart';
import 'package:flutter_mobile/data/model/prescription/prescription_model.dart';

abstract class PrescriptionRemoteDataSource {
  Future<List<PrescriptionModel>> getPrescriptions();
  Future<PrescriptionModel> getPrescriptionById(String id);

  // New methods for creating prescriptions
  Future<PrescriptionModel> createPrescription(
      CreatePrescriptionRequestModel request,
      );

  Future<PrescriptionModel> updatePrescription({
    required String id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<void> deletePrescription(String id);
}