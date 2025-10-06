// lib/presentation/bloc/user_management/user_prescription_state.dart
part of 'user_prescription_cubit.dart';

class UserPrescriptionState extends Equatable {
  const UserPrescriptionState({
    // User and Group context
    this.userId = '',
    this.groupId = '',

    // Main prescription data
    this.allPrescriptions = const [],
    this.filteredPrescriptions = const [],
    this.selectedPrescription,
    this.selectedPrescriptionId = '',

    // Treatment data
    this.treatments = const [],

    // Loading states for different operations
    this.status = FormzSubmissionStatus.initial,
    this.detailStatus = FormzSubmissionStatus.initial,
    this.createStatus = FormzSubmissionStatus.initial,
    this.updateStatus = FormzSubmissionStatus.initial,
    this.deleteStatus = FormzSubmissionStatus.initial,

    // Treatment loading states
    this.treatmentStatus = FormzSubmissionStatus.initial,
    this.createTreatmentStatus = FormzSubmissionStatus.initial,
    this.updateTreatmentStatus = FormzSubmissionStatus.initial,
    this.deleteTreatmentStatus = FormzSubmissionStatus.initial,

    // Error messages for different operations
    this.errorMessage,
    this.detailErrorMessage,
    this.createErrorMessage,
    this.updateErrorMessage,
    this.deleteErrorMessage,
    this.successMessage,

    // Treatment error messages
    this.treatmentErrorMessage,
    this.createTreatmentErrorMessage,
    this.updateTreatmentErrorMessage,
    this.deleteTreatmentErrorMessage,

    // Search and filter
    this.searchQuery = '',
    this.selectedFilter = 'all',

    // Form data for creating/editing prescriptions
    this.formName = '',
    this.formStartDate,
    this.formEndDate,
    this.formDiseaseIds = const [],
  });

  // ============================================
  // User and Group Context
  // ============================================
  final String userId;
  final String groupId;

  // ============================================
  // Prescription Data Properties
  // ============================================
  final List<PrescriptionEntity> allPrescriptions;
  final List<PrescriptionEntity> filteredPrescriptions;
  final PrescriptionEntity? selectedPrescription;
  final String selectedPrescriptionId;

  // ============================================
  // Treatment Data Properties
  // ============================================
  final List<TreatmentEntity> treatments;

  // ============================================
  // Loading State Properties
  // ============================================
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus detailStatus;
  final FormzSubmissionStatus createStatus;
  final FormzSubmissionStatus updateStatus;
  final FormzSubmissionStatus deleteStatus;

  // Treatment loading states
  final FormzSubmissionStatus treatmentStatus;
  final FormzSubmissionStatus createTreatmentStatus;
  final FormzSubmissionStatus updateTreatmentStatus;
  final FormzSubmissionStatus deleteTreatmentStatus;

  // ============================================
  // Error and Success Message Properties
  // ============================================
  final String? errorMessage;
  final String? detailErrorMessage;
  final String? createErrorMessage;
  final String? updateErrorMessage;
  final String? deleteErrorMessage;
  final String? successMessage;

  // Treatment error messages
  final String? treatmentErrorMessage;
  final String? createTreatmentErrorMessage;
  final String? updateTreatmentErrorMessage;
  final String? deleteTreatmentErrorMessage;

  // ============================================
  // Search and Filter Properties
  // ============================================
  final String searchQuery;
  final String selectedFilter;

  // ============================================
  // Form Data Properties
  // ============================================
  final String formName;
  final DateTime? formStartDate;
  final DateTime? formEndDate;
  final List<String> formDiseaseIds;

  // ============================================
  // State Copy Method
  // ============================================
  UserPrescriptionState copyWith({
    String? userId,
    String? groupId,
    List<PrescriptionEntity>? allPrescriptions,
    List<PrescriptionEntity>? filteredPrescriptions,
    PrescriptionEntity? selectedPrescription,
    String? selectedPrescriptionId,
    List<TreatmentEntity>? treatments,

    FormzSubmissionStatus? status,
    FormzSubmissionStatus? detailStatus,
    FormzSubmissionStatus? createStatus,
    FormzSubmissionStatus? updateStatus,
    FormzSubmissionStatus? deleteStatus,

    FormzSubmissionStatus? treatmentStatus,
    FormzSubmissionStatus? createTreatmentStatus,
    FormzSubmissionStatus? updateTreatmentStatus,
    FormzSubmissionStatus? deleteTreatmentStatus,

    String? errorMessage,
    String? detailErrorMessage,
    String? createErrorMessage,
    String? updateErrorMessage,
    String? deleteErrorMessage,
    String? successMessage,

    String? treatmentErrorMessage,
    String? createTreatmentErrorMessage,
    String? updateTreatmentErrorMessage,
    String? deleteTreatmentErrorMessage,

    String? searchQuery,
    String? selectedFilter,

    String? formName,
    DateTime? formStartDate,
    DateTime? formEndDate,
    List<String>? formDiseaseIds,
  }) {
    return UserPrescriptionState(
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      allPrescriptions: allPrescriptions ?? this.allPrescriptions,
      filteredPrescriptions: filteredPrescriptions ?? this.filteredPrescriptions,
      selectedPrescription: selectedPrescription,
      selectedPrescriptionId: selectedPrescriptionId ?? this.selectedPrescriptionId,
      treatments: treatments ?? this.treatments,

      status: status ?? this.status,
      detailStatus: detailStatus ?? this.detailStatus,
      createStatus: createStatus ?? this.createStatus,
      updateStatus: updateStatus ?? this.updateStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,

      treatmentStatus: treatmentStatus ?? this.treatmentStatus,
      createTreatmentStatus: createTreatmentStatus ?? this.createTreatmentStatus,
      updateTreatmentStatus: updateTreatmentStatus ?? this.updateTreatmentStatus,
      deleteTreatmentStatus: deleteTreatmentStatus ?? this.deleteTreatmentStatus,

      errorMessage: errorMessage,
      detailErrorMessage: detailErrorMessage,
      createErrorMessage: createErrorMessage,
      updateErrorMessage: updateErrorMessage,
      deleteErrorMessage: deleteErrorMessage,
      successMessage: successMessage,

      treatmentErrorMessage: treatmentErrorMessage,
      createTreatmentErrorMessage: createTreatmentErrorMessage,
      updateTreatmentErrorMessage: updateTreatmentErrorMessage,
      deleteTreatmentErrorMessage: deleteTreatmentErrorMessage,

      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,

      formName: formName ?? this.formName,
      formStartDate: formStartDate ?? this.formStartDate,
      formEndDate: formEndDate,
      formDiseaseIds: formDiseaseIds ?? this.formDiseaseIds,
    );
  }

  // ============================================
  // Convenience Getters
  // ============================================

  // User and group validation
  bool get hasUserAndGroup => userId.isNotEmpty && groupId.isNotEmpty;

  // Main loading states
  bool get isLoading => status == FormzSubmissionStatus.inProgress;
  bool get isSuccess => status == FormzSubmissionStatus.success;
  bool get isFailure => status == FormzSubmissionStatus.failure;
  bool get hasError => errorMessage != null;
  bool get hasSuccess => successMessage != null;
  bool get hasPrescriptions => allPrescriptions.isNotEmpty;

  // Detail loading states
  bool get isDetailLoading => detailStatus == FormzSubmissionStatus.inProgress;
  bool get isDetailSuccess => detailStatus == FormzSubmissionStatus.success;
  bool get isDetailFailure => detailStatus == FormzSubmissionStatus.failure;
  bool get hasDetailError => detailErrorMessage != null;

  // Create loading states
  bool get isCreateLoading => createStatus == FormzSubmissionStatus.inProgress;
  bool get isCreateSuccess => createStatus == FormzSubmissionStatus.success;
  bool get isCreateFailure => createStatus == FormzSubmissionStatus.failure;
  bool get hasCreateError => createErrorMessage != null;

  // Update loading states
  bool get isUpdateLoading => updateStatus == FormzSubmissionStatus.inProgress;
  bool get isUpdateSuccess => updateStatus == FormzSubmissionStatus.success;
  bool get isUpdateFailure => updateStatus == FormzSubmissionStatus.failure;
  bool get hasUpdateError => updateErrorMessage != null;

  // Delete loading states
  bool get isDeleteLoading => deleteStatus == FormzSubmissionStatus.inProgress;
  bool get isDeleteSuccess => deleteStatus == FormzSubmissionStatus.success;
  bool get isDeleteFailure => deleteStatus == FormzSubmissionStatus.failure;
  bool get hasDeleteError => deleteErrorMessage != null;

  // Treatment loading states
  bool get isTreatmentLoading => treatmentStatus == FormzSubmissionStatus.inProgress;
  bool get isTreatmentSuccess => treatmentStatus == FormzSubmissionStatus.success;
  bool get isTreatmentFailure => treatmentStatus == FormzSubmissionStatus.failure;
  bool get hasTreatmentError => treatmentErrorMessage != null;

  bool get isCreateTreatmentLoading => createTreatmentStatus == FormzSubmissionStatus.inProgress;
  bool get isCreateTreatmentSuccess => createTreatmentStatus == FormzSubmissionStatus.success;
  bool get isCreateTreatmentFailure => createTreatmentStatus == FormzSubmissionStatus.failure;
  bool get hasCreateTreatmentError => createTreatmentErrorMessage != null;

  bool get isUpdateTreatmentLoading => updateTreatmentStatus == FormzSubmissionStatus.inProgress;
  bool get isUpdateTreatmentSuccess => updateTreatmentStatus == FormzSubmissionStatus.success;
  bool get isUpdateTreatmentFailure => updateTreatmentStatus == FormzSubmissionStatus.failure;
  bool get hasUpdateTreatmentError => updateTreatmentErrorMessage != null;

  bool get isDeleteTreatmentLoading => deleteTreatmentStatus == FormzSubmissionStatus.inProgress;
  bool get isDeleteTreatmentSuccess => deleteTreatmentStatus == FormzSubmissionStatus.success;
  bool get isDeleteTreatmentFailure => deleteTreatmentStatus == FormzSubmissionStatus.failure;
  bool get hasDeleteTreatmentError => deleteTreatmentErrorMessage != null;

  // Search and filter states
  bool get hasSearchQuery => searchQuery.isNotEmpty;
  bool get isFiltered => selectedFilter != 'all';

  // Form validation
  bool get isFormValid => formName.isNotEmpty && formStartDate != null;

  // Statistics
  int get totalPrescriptions => allPrescriptions.length;
  int get activePrescriptions => allPrescriptions.where((p) => p.isActive).length;
  int get completedPrescriptions => totalPrescriptions - activePrescriptions;

  @override
  List<Object?> get props => [
    userId,
    groupId,
    allPrescriptions,
    filteredPrescriptions,
    selectedPrescription,
    selectedPrescriptionId,
    treatments,
    status,
    detailStatus,
    createStatus,
    updateStatus,
    deleteStatus,
    treatmentStatus,
    createTreatmentStatus,
    updateTreatmentStatus,
    deleteTreatmentStatus,
    errorMessage,
    detailErrorMessage,
    createErrorMessage,
    updateErrorMessage,
    deleteErrorMessage,
    successMessage,
    treatmentErrorMessage,
    createTreatmentErrorMessage,
    updateTreatmentErrorMessage,
    deleteTreatmentErrorMessage,
    searchQuery,
    selectedFilter,
    formName,
    formStartDate,
    formEndDate,
    formDiseaseIds,
  ];
}