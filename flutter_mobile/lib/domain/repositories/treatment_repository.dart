import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_treatment_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/treatment_entity.dart';


abstract class TreatmentRepository {
  Future<DataState<List<TreatmentEntity>>> getTreatmentsByPrescriptionId(String prescriptionId);
  Future<DataState<TreatmentEntity>> getTreatmentById(String id);

  // New methods for creating treatments
  Future<DataState<TreatmentEntity>> createTreatment(
      CreateTreatmentEntity treatment,
      );

  Future<DataState<TreatmentEntity>> updateTreatment({
    required String id,
    String? dosage,
    String? frequency,
    int? durationDays,
  });

  Future<DataState<void>> deleteTreatment(String id);
}