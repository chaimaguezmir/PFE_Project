part of 'prescription_creation_cubit.dart';

class PrescriptionCreationState extends Equatable {
  const PrescriptionCreationState({
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.name = '',
    this.diseases = const [],
    this.diseasesStatus = FormzSubmissionStatus.initial,
    this.diseasesErrorMessage,
    this.selectedDiseaseId,
    this.pharmacyBoxes = const [],
    this.pharmacyBoxesStatus = FormzSubmissionStatus.initial,
    this.pharmacyBoxesErrorMessage,
    this.selectedPharmacyBoxId,
    this.medicines = const [],
    this.medicinesStatus = FormzSubmissionStatus.initial,
    this.medicinesErrorMessage,
    this.selectedMedicineId,
    // Treatment form defaults
    this.treatmentSelectedBox = '',
    this.treatmentSelectedMedicineId = '',
    this.treatmentSelectedDosage = 1,
    this.treatmentSelectedFrequency = 'Chaque jour',
    this.treatmentSelectedDurationDays = 30,
    this.treatmentSelectedMoments = const {'Matin', 'Après Midi'},
    this.treatmentMealTiming = 'Avant repas',
    this.treatmentSearchQuery = '',
    this.treatments = const [],
  });

  final FormzSubmissionStatus status;
  final String? errorMessage;
  final String name;
  final List<DiseaseEntity> diseases;
  final FormzSubmissionStatus diseasesStatus;
  final String? diseasesErrorMessage;
  final String? selectedDiseaseId;
  final List<PharmacyBoxEntity> pharmacyBoxes;
  final FormzSubmissionStatus pharmacyBoxesStatus;
  final String? pharmacyBoxesErrorMessage;
  final String? selectedPharmacyBoxId;

  final List<MyMedicineEntity> medicines;
  final FormzSubmissionStatus medicinesStatus;
  final String? medicinesErrorMessage;
  final String? selectedMedicineId;

  // Treatment form state
  final String treatmentSelectedBox;
  final String treatmentSelectedMedicineId;
  final int treatmentSelectedDosage;
  final String treatmentSelectedFrequency;
  final int treatmentSelectedDurationDays;
  final Set<String> treatmentSelectedMoments;
  final String treatmentMealTiming;
  final String treatmentSearchQuery;

  // Saved treatments list (each element is a Map with the selected values)
  final List<Map<String, dynamic>> treatments;

  PrescriptionCreationState copyWith({
    FormzSubmissionStatus? status,
    String? errorMessage,
    String? name,
    List<DiseaseEntity>? diseases,
    FormzSubmissionStatus? diseasesStatus,
    String? diseasesErrorMessage,
    String? selectedDiseaseId,
    List<PharmacyBoxEntity>? pharmacyBoxes,
    FormzSubmissionStatus? pharmacyBoxesStatus,
    String? pharmacyBoxesErrorMessage,
    String? selectedPharmacyBoxId,
    List<MyMedicineEntity>? medicines,
    FormzSubmissionStatus? medicinesStatus,
    String? medicinesErrorMessage,
    String? selectedMedicineId,
    // treatment fields
    String? treatmentSelectedBox,
    String? treatmentSelectedMedicineId,
    int? treatmentSelectedDosage,
    String? treatmentSelectedFrequency,
    int? treatmentSelectedDurationDays,
    Set<String>? treatmentSelectedMoments,
    String? treatmentMealTiming,
    String? treatmentSearchQuery,
    List<Map<String, dynamic>>? treatments,
  }) {
    return PrescriptionCreationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      name: name ?? this.name,
      diseases: diseases ?? this.diseases,
      diseasesStatus: diseasesStatus ?? this.diseasesStatus,
      diseasesErrorMessage: diseasesErrorMessage ?? this.diseasesErrorMessage,
      selectedDiseaseId: selectedDiseaseId ?? this.selectedDiseaseId,
      pharmacyBoxes: pharmacyBoxes ?? this.pharmacyBoxes,
      pharmacyBoxesStatus: pharmacyBoxesStatus ?? this.pharmacyBoxesStatus,
      pharmacyBoxesErrorMessage:
      pharmacyBoxesErrorMessage ?? this.pharmacyBoxesErrorMessage,
      selectedPharmacyBoxId:
      selectedPharmacyBoxId ?? this.selectedPharmacyBoxId,
      medicines: medicines ?? this.medicines,
      medicinesStatus: medicinesStatus ?? this.medicinesStatus,
      medicinesErrorMessage: medicinesErrorMessage ?? this.medicinesErrorMessage,
      selectedMedicineId: selectedMedicineId ?? this.selectedMedicineId,
      // treatment
      treatmentSelectedBox: treatmentSelectedBox ?? this.treatmentSelectedBox,
      treatmentSelectedMedicineId:
      treatmentSelectedMedicineId ?? this.treatmentSelectedMedicineId,
      treatmentSelectedDosage:
      treatmentSelectedDosage ?? this.treatmentSelectedDosage,
      treatmentSelectedFrequency:
      treatmentSelectedFrequency ?? this.treatmentSelectedFrequency,
      treatmentSelectedDurationDays:
      treatmentSelectedDurationDays ?? this.treatmentSelectedDurationDays,
      treatmentSelectedMoments:
      treatmentSelectedMoments ?? this.treatmentSelectedMoments,
      treatmentMealTiming: treatmentMealTiming ?? this.treatmentMealTiming,
      treatmentSearchQuery:
      treatmentSearchQuery ?? this.treatmentSearchQuery,
      treatments: treatments ?? this.treatments,
    );
  }

  bool get isDiseasesLoading =>
      diseasesStatus == FormzSubmissionStatus.inProgress;
  bool get isDiseasesSuccess => diseasesStatus == FormzSubmissionStatus.success;
  bool get isDiseasesFailure => diseasesStatus == FormzSubmissionStatus.failure;
  bool get hasDiseases => diseases.isNotEmpty;
  bool get hasDiseasesError => diseasesErrorMessage != null;
  bool get isLoading => status == FormzSubmissionStatus.inProgress;
  bool get isSuccess => status == FormzSubmissionStatus.success;
  bool get isFailure => status == FormzSubmissionStatus.failure;
  bool get hasError => errorMessage != null;
  bool get isNameValid => name.trim().isNotEmpty;
  bool get canProceed => isNameValid && hasDiseases;
  bool get hasAnyLoading => isLoading || isDiseasesLoading;
  bool get hasAnyError => hasError || hasDiseasesError;

  // Pharmacy box getters
  bool get isPharmacyBoxesLoading =>
      pharmacyBoxesStatus == FormzSubmissionStatus.inProgress;
  bool get isPharmacyBoxesSuccess =>
      pharmacyBoxesStatus == FormzSubmissionStatus.success;
  bool get isPharmacyBoxesFailure =>
      pharmacyBoxesStatus == FormzSubmissionStatus.failure;
  bool get hasPharmacyBoxes => pharmacyBoxes.isNotEmpty;
  bool get hasPharmacyBoxesError => pharmacyBoxesErrorMessage != null;

  // Medicine getters
  bool get isMedicinesLoading =>
      medicinesStatus == FormzSubmissionStatus.inProgress;
  bool get isMedicinesSuccess =>
      medicinesStatus == FormzSubmissionStatus.success;
  bool get isMedicinesFailure =>
      medicinesStatus == FormzSubmissionStatus.failure;
  bool get hasMedicines => medicines.isNotEmpty;
  bool get hasMedicinesError => medicinesErrorMessage != null;

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    name,
    diseases,
    diseasesStatus,
    diseasesErrorMessage,
    selectedDiseaseId,
    pharmacyBoxes,
    pharmacyBoxesStatus,
    pharmacyBoxesErrorMessage,
    selectedPharmacyBoxId,
    medicines,
    medicinesStatus,
    medicinesErrorMessage,
    selectedMedicineId,
    // treatment fields
    treatmentSelectedBox,
    treatmentSelectedMedicineId,
    treatmentSelectedDosage,
    treatmentSelectedFrequency,
    treatmentSelectedDurationDays,
    treatmentSelectedMoments,
    treatmentMealTiming,
    treatmentSearchQuery,
    treatments,
  ];
}