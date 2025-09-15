// lib/domain/repositories/prescription_repository.dart
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/prescription/prescription_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_prescription_entity.dart';

abstract class PrescriptionRepository {
  Future<DataState<List<PrescriptionEntity>>> getPrescriptions();
  Future<DataState<PrescriptionEntity>> getPrescriptionById(String id);

  // New methods for creating prescriptions
  Future<DataState<PrescriptionEntity>> createPrescription(
      CreatePrescriptionEntity prescription,
      );

  Future<DataState<PrescriptionEntity>> updatePrescription({
    required String id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<DataState<void>> deletePrescription(String id);
}