import 'package:flutter_mobile/data/model/prescription/prescription_model.dart';

abstract class PrescriptionRemoteDataSource {
  Future<List<PrescriptionModel>> getPrescriptions();
  Future<PrescriptionModel> getPrescriptionById(String id);
  Future<PrescriptionModel> createPrescription({
    required String name,
    required DateTime startDate,
    DateTime? endDate,
    required List<String> diseaseIds,
  });
  Future<PrescriptionModel> updatePrescription({
    required String id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<void> deletePrescription(String id);
}