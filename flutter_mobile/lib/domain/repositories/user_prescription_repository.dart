import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/prescription/prescription_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_prescription_entity.dart';

abstract class UserPrescriptionRepository {
  /// Get all prescriptions for a specific user in a group
  Future<DataState<List<PrescriptionEntity>>> getUserPrescriptions({
    required String groupId,
    required String userId,
  });

  /// Get a specific prescription by ID for a user
  Future<DataState<PrescriptionEntity>> getUserPrescriptionById({
    required String groupId,
    required String userId,
    required String prescriptionId,
  });

  /// Create a prescription for a user
  Future<DataState<PrescriptionEntity>> createUserPrescription({
    required String groupId,
    required String userId,
    required CreatePrescriptionEntity createPrescriptionEntity,
  });

  /// Update a user's prescription
  Future<DataState<PrescriptionEntity>> updateUserPrescription({
    required String groupId,
    required String userId,
    required String prescriptionId,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Delete a user's prescription
  Future<DataState<void>> deleteUserPrescription({
    required String groupId,
    required String userId,
    required String prescriptionId,
  });
}