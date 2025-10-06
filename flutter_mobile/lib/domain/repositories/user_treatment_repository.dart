import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/prescription/treatment_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_treatment_entity.dart';

abstract class UserTreatmentRepository {
  /// Get all treatments for a specific user in a group
  Future<DataState<List<TreatmentEntity>>> getUserTreatments({
    required String groupId,
    required String userId,
  });

  /// Get treatments by prescription for a user
  Future<DataState<List<TreatmentEntity>>> getUserTreatmentsByPrescription({
    required String groupId,
    required String userId,
    required String prescriptionId,
  });

  /// Get a specific treatment by ID for a user
  Future<DataState<TreatmentEntity>> getUserTreatmentById({
    required String groupId,
    required String userId,
    required String treatmentId,
  });

  /// Create a treatment for a user
  Future<DataState<TreatmentEntity>> createUserTreatment({
    required String groupId,
    required String userId,
    required CreateTreatmentEntity createTreatmentEntity,
  });

  /// Update a user's treatment
  Future<DataState<TreatmentEntity>> updateUserTreatment({
    required String groupId,
    required String userId,
    required String treatmentId,
    String? dosage,
    String? frequency,
    int? durationDays,
  });

  /// Delete a user's treatment
  Future<DataState<void>> deleteUserTreatment({
    required String groupId,
    required String userId,
    required String treatmentId,
  });
}