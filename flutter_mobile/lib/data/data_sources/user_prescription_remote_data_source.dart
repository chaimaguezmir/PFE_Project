import 'package:flutter_mobile/data/model/prescription/prescription_model.dart';
import 'package:flutter_mobile/data/model/prescription/create_prescription_request_model.dart';

abstract class UserPrescriptionRemoteDataSource {
  /// Get all prescriptions for a specific user in a group
  Future<List<PrescriptionModel>> getUserPrescriptions({
    required String groupId,
    required String userId,
  });

  /// Get a specific prescription by ID for a user
  Future<PrescriptionModel> getUserPrescriptionById({
    required String groupId,
    required String userId,
    required String prescriptionId,
  });

  /// Create a prescription for a user
  Future<PrescriptionModel> createUserPrescription({
    required String groupId,
    required String userId,
    required CreatePrescriptionRequestModel request,
  });

  /// Update a user's prescription
  Future<PrescriptionModel> updateUserPrescription({
    required String groupId,
    required String userId,
    required String prescriptionId,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Delete a user's prescription
  Future<void> deleteUserPrescription({
    required String groupId,
    required String userId,
    required String prescriptionId,
  });
}