import 'package:flutter_mobile/data/model/prescription/treatment_model.dart';
import 'package:flutter_mobile/data/model/prescription/create_treatment_request_model.dart';

abstract class UserTreatmentRemoteDataSource {
  /// Get all treatments for a specific user in a group
  Future<List<TreatmentModel>> getUserTreatments({
    required String groupId,
    required String userId,
  });

  /// Get treatments by prescription for a user
  Future<List<TreatmentModel>> getUserTreatmentsByPrescription({
    required String groupId,
    required String userId,
    required String prescriptionId,
  });

  /// Get a specific treatment by ID for a user
  Future<TreatmentModel> getUserTreatmentById({
    required String groupId,
    required String userId,
    required String treatmentId,
  });

  /// Create a treatment for a user
  Future<TreatmentModel> createUserTreatment({
    required String groupId,
    required String userId,
    required CreateTreatmentRequestModel request,
  });

  /// Update a user's treatment
  Future<TreatmentModel> updateUserTreatment({
    required String groupId,
    required String userId,
    required String treatmentId,
    String? dosage,
    String? frequency,
    int? durationDays,
  });

  /// Delete a user's treatment
  Future<void> deleteUserTreatment({
    required String groupId,
    required String userId,
    required String treatmentId,
  });
}