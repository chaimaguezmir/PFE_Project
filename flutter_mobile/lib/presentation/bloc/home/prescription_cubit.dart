// lib/presentation/bloc/prescription/prescription_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/prescription/prescription_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/treatment_entity.dart';
import 'package:flutter_mobile/domain/repositories/prescription_repository.dart';
import 'package:flutter_mobile/domain/repositories/treatment_repository.dart';
import 'package:formz/formz.dart';

part 'prescription_state.dart';

class PrescriptionCubit extends Cubit<PrescriptionState> {
  PrescriptionCubit(this._prescriptionRepository, this._treatmentRepository)
      : super(const PrescriptionState());

  final PrescriptionRepository _prescriptionRepository;
  final TreatmentRepository _treatmentRepository;

  // ============================================
  // Prescription Fetching Methods
  // ============================================

  /// Fetch all prescriptions from the server
  Future<void> fetchPrescriptions() async {
    emit(state.copyWith(
      status: FormzSubmissionStatus.inProgress,
      errorMessage: null,
    ));

    final result = await _prescriptionRepository.getPrescriptions();

    if (result is DataSuccess<List<PrescriptionEntity>>) {
      final prescriptions = result.data ?? [];
      emit(state.copyWith(
        allPrescriptions: prescriptions,
        filteredPrescriptions: prescriptions,
        status: FormzSubmissionStatus.success,
        errorMessage: null,
      ));
    } else {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: result.error ?? 'Échec du chargement des prescriptions',
      ));
    }
  }

  /// Fetch a specific prescription by ID
  Future<void> fetchPrescriptionById(String id) async {
    emit(state.copyWith(
      detailStatus: FormzSubmissionStatus.inProgress,
      detailErrorMessage: null,
    ));

    final result = await _prescriptionRepository.getPrescriptionById(id);

    if (result is DataSuccess<PrescriptionEntity>) {
      emit(state.copyWith(
        selectedPrescription: result.data,
        detailStatus: FormzSubmissionStatus.success,
        detailErrorMessage: null,
      ));
    } else {
      emit(state.copyWith(
        detailStatus: FormzSubmissionStatus.failure,
        detailErrorMessage: result.error ?? 'Échec du chargement de la prescription',
      ));
    }
  }

  /// Refresh prescriptions list
  Future<void> refreshPrescriptions() async {
    await fetchPrescriptions();
  }

  // ============================================
  // Search and Filter Methods
  // ============================================

  /// Filter prescriptions based on search query
  void searchPrescriptions(String query, List<PrescriptionEntity> allPrescriptions) {
    if (query.isEmpty) {
      emit(state.copyWith(
        filteredPrescriptions: allPrescriptions,
        searchQuery: query,
      ));
      return;
    }

    final filteredPrescriptions = allPrescriptions
        .where((prescription) =>
    prescription.name.toLowerCase().contains(query.toLowerCase()) ||
        prescription.primaryDiseaseName.toLowerCase().contains(query.toLowerCase()) ||
        prescription.diseases.any((disease) =>
            disease.name.toLowerCase().contains(query.toLowerCase())))
        .toList();

    emit(state.copyWith(
      filteredPrescriptions: filteredPrescriptions,
      searchQuery: query,
    ));
  }

  /// Reset search to show all prescriptions
  void resetSearch(List<PrescriptionEntity> allPrescriptions) {
    emit(state.copyWith(
      filteredPrescriptions: allPrescriptions,
      searchQuery: '',
    ));
  }

  /// Clear search and reset to all prescriptions
  void clearSearch() {
    emit(state.copyWith(
      filteredPrescriptions: state.allPrescriptions,
      searchQuery: '',
    ));
  }

  /// Filter prescriptions by status (active, completed, all)
  void filterByStatus(String status) {
    List<PrescriptionEntity> filtered;

    switch (status.toLowerCase()) {
      case 'active':
        filtered = state.allPrescriptions.where((p) => p.isActive).toList();
        break;
      case 'completed':
        filtered = state.allPrescriptions.where((p) => !p.isActive).toList();
        break;
      case 'all':
      default:
        filtered = state.allPrescriptions;
        break;
    }

    emit(state.copyWith(
      filteredPrescriptions: filtered,
      selectedFilter: status,
    ));
  }

  // ============================================
  // Treatment Management Methods
  // ============================================

  /// Set selected prescription ID and fetch its treatments
  Future<void> selectPrescriptionAndFetchTreatments(String prescriptionId) async {
    emit(state.copyWith(selectedPrescriptionId: prescriptionId));
    await fetchTreatments(prescriptionId);
  }

  /// Fetch treatments for a specific prescription
  Future<void> fetchTreatments(String prescriptionId) async {
    emit(state.copyWith(
      treatmentStatus: FormzSubmissionStatus.inProgress,
      treatmentErrorMessage: null,
    ));

    final result = await _treatmentRepository.getTreatmentsByPrescriptionId(prescriptionId);

    if (result is DataSuccess<List<TreatmentEntity>>) {
      emit(state.copyWith(
        treatments: result.data ?? [],
        treatmentStatus: FormzSubmissionStatus.success,
        treatmentErrorMessage: null,
      ));
    } else {
      emit(state.copyWith(
        treatmentStatus: FormzSubmissionStatus.failure,
        treatmentErrorMessage: result.error ?? 'Échec du chargement des traitements',
      ));
    }
  }

  /// Create a new treatment
  Future<void> createTreatment({
    required String prescriptionId,
    required String myMedicineId,
    required String dosage,
    required String frequency,
    required int durationDays,
  }) async {
    emit(state.copyWith(
      createTreatmentStatus: FormzSubmissionStatus.inProgress,
      createTreatmentErrorMessage: null,
    ));

    final result = await _treatmentRepository.createTreatment(
      prescriptionId: prescriptionId,
      myMedicineId: myMedicineId,
      dosage: dosage,
      frequency: frequency,
      durationDays: durationDays,
    );

    if (result is DataSuccess<TreatmentEntity>) {
      emit(state.copyWith(
        createTreatmentStatus: FormzSubmissionStatus.success,
        successMessage: 'Traitement créé avec succès',
        createTreatmentErrorMessage: null,
      ));

      // Refresh treatments for current prescription
      if (state.selectedPrescriptionId.isNotEmpty) {
        await fetchTreatments(state.selectedPrescriptionId);
      }
    } else {
      emit(state.copyWith(
        createTreatmentStatus: FormzSubmissionStatus.failure,
        createTreatmentErrorMessage: result.error ?? 'Échec de la création du traitement',
      ));
    }
  }

  /// Update an existing treatment
  Future<void> updateTreatment({
    required String id,
    String? dosage,
    String? frequency,
    int? durationDays,
  }) async {
    emit(state.copyWith(
      updateTreatmentStatus: FormzSubmissionStatus.inProgress,
      updateTreatmentErrorMessage: null,
    ));

    final result = await _treatmentRepository.updateTreatment(
      id: id,
      dosage: dosage,
      frequency: frequency,
      durationDays: durationDays,
    );

    if (result is DataSuccess<TreatmentEntity>) {
      emit(state.copyWith(
        updateTreatmentStatus: FormzSubmissionStatus.success,
        successMessage: 'Traitement mis à jour avec succès',
        updateTreatmentErrorMessage: null,
      ));

      // Refresh treatments for current prescription
      if (state.selectedPrescriptionId.isNotEmpty) {
        await fetchTreatments(state.selectedPrescriptionId);
      }
    } else {
      emit(state.copyWith(
        updateTreatmentStatus: FormzSubmissionStatus.failure,
        updateTreatmentErrorMessage: result.error ?? 'Échec de la mise à jour du traitement',
      ));
    }
  }

  /// Delete a treatment
  Future<void> deleteTreatment(String id) async {
    emit(state.copyWith(
      deleteTreatmentStatus: FormzSubmissionStatus.inProgress,
      deleteTreatmentErrorMessage: null,
    ));

    final result = await _treatmentRepository.deleteTreatment(id);

    if (result is DataSuccess<void>) {
      emit(state.copyWith(
        deleteTreatmentStatus: FormzSubmissionStatus.success,
        successMessage: 'Traitement supprimé avec succès',
        deleteTreatmentErrorMessage: null,
      ));

      // Refresh treatments for current prescription
      if (state.selectedPrescriptionId.isNotEmpty) {
        await fetchTreatments(state.selectedPrescriptionId);
      }
    } else {
      emit(state.copyWith(
        deleteTreatmentStatus: FormzSubmissionStatus.failure,
        deleteTreatmentErrorMessage: result.error ?? 'Échec de la suppression du traitement',
      ));
    }
  }

  /// Clear selected prescription and treatments
  void clearSelectedPrescriptionAndTreatments() {
    emit(state.copyWith(
      selectedPrescriptionId: '',
      treatments: [],
      treatmentStatus: FormzSubmissionStatus.initial,
      treatmentErrorMessage: null,
    ));
  }

  // ============================================
  // Prescription Management Methods
  // ============================================

  /// Create a new prescription
  Future<void> createPrescription({
    required String name,
    required DateTime startDate,
    DateTime? endDate,
    required List<String> diseaseIds,
  }) async {
    emit(state.copyWith(
      createStatus: FormzSubmissionStatus.inProgress,
      createErrorMessage: null,
    ));

    final result = await _prescriptionRepository.createPrescription(
      name: name,
      startDate: startDate,
      endDate: endDate,
      diseaseIds: diseaseIds,
    );

    if (result is DataSuccess<PrescriptionEntity>) {
      emit(state.copyWith(
        createStatus: FormzSubmissionStatus.success,
        successMessage: 'Prescription créée avec succès',
        createErrorMessage: null,
      ));

      // Refresh the list to include the new prescription
      await fetchPrescriptions();
    } else {
      emit(state.copyWith(
        createStatus: FormzSubmissionStatus.failure,
        createErrorMessage: result.error ?? 'Échec de la création de la prescription',
      ));
    }
  }

  /// Update an existing prescription
  Future<void> updatePrescription({
    required String id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(state.copyWith(
      updateStatus: FormzSubmissionStatus.inProgress,
      updateErrorMessage: null,
    ));

    final result = await _prescriptionRepository.updatePrescription(
      id: id,
      name: name,
      startDate: startDate,
      endDate: endDate,
    );

    if (result is DataSuccess<PrescriptionEntity>) {
      emit(state.copyWith(
        updateStatus: FormzSubmissionStatus.success,
        successMessage: 'Prescription mise à jour avec succès',
        updateErrorMessage: null,
      ));

      // Refresh the list to reflect changes
      await fetchPrescriptions();
    } else {
      emit(state.copyWith(
        updateStatus: FormzSubmissionStatus.failure,
        updateErrorMessage: result.error ?? 'Échec de la mise à jour de la prescription',
      ));
    }
  }

  /// Delete a prescription
  Future<void> deletePrescription(String id) async {
    emit(state.copyWith(
      deleteStatus: FormzSubmissionStatus.inProgress,
      deleteErrorMessage: null,
    ));

    final result = await _prescriptionRepository.deletePrescription(id);

    if (result is DataSuccess<void>) {
      emit(state.copyWith(
        deleteStatus: FormzSubmissionStatus.success,
        successMessage: 'Prescription supprimée avec succès',
        deleteErrorMessage: null,
      ));

      // Refresh the list to remove the deleted prescription
      await fetchPrescriptions();
    } else {
      emit(state.copyWith(
        deleteStatus: FormzSubmissionStatus.failure,
        deleteErrorMessage: result.error ?? 'Échec de la suppression de la prescription',
      ));
    }
  }

  // ============================================
  // Form Management Methods
  // ============================================

  /// Set the selected prescription for editing
  void selectPrescription(PrescriptionEntity prescription) {
    emit(state.copyWith(selectedPrescription: prescription));
  }

  /// Clear the selected prescription
  void clearSelectedPrescription() {
    emit(state.copyWith(selectedPrescription: null));
  }

  /// Set form data for prescription creation/editing
  void setFormData({
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? diseaseIds,
  }) {
    emit(state.copyWith(
      formName: name ?? state.formName,
      formStartDate: startDate ?? state.formStartDate,
      formEndDate: endDate,
      formDiseaseIds: diseaseIds ?? state.formDiseaseIds,
    ));
  }

  /// Clear form data
  void clearFormData() {
    emit(state.copyWith(
      formName: '',
      formStartDate: null,
      formEndDate: null,
      formDiseaseIds: [],
    ));
  }

  // ============================================
  // Utility Methods
  // ============================================

  /// Clear all error messages
  void clearError() {
    emit(state.copyWith(
      errorMessage: null,
      detailErrorMessage: null,
      createErrorMessage: null,
      updateErrorMessage: null,
      deleteErrorMessage: null,
      treatmentErrorMessage: null,
      createTreatmentErrorMessage: null,
      updateTreatmentErrorMessage: null,
      deleteTreatmentErrorMessage: null,
    ));
  }

  /// Clear success message
  void clearSuccess() {
    emit(state.copyWith(successMessage: null));
  }

  /// Reset entire state to initial values
  void resetState() {
    emit(const PrescriptionState());
  }

  /// Get prescription statistics
  Map<String, int> getPrescriptionStats() {
    final total = state.allPrescriptions.length;
    final active = state.allPrescriptions.where((p) => p.isActive).length;
    final completed = total - active;

    return {
      'total': total,
      'active': active,
      'completed': completed,
    };
  }
}