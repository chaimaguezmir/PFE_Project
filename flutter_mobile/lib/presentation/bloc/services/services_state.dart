part of 'services_cubit.dart';

class ServicesState extends Equatable {
  const ServicesState({
    // medication tracking properties
    this.selectedExpirationDate,
    this.selectedQuantity = 0,
    this.shouldClearControllers = false,

    // Barcode Scan related
    this.scannedMedicine,
    this.scanStatus = FormzSubmissionStatus.initial,
    this.scanErrorMessage,
    this.scannedBarcode = '',

    // Pharmacy Box related
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.allBoxes = const [],
    this.filteredBoxes = const [],
    this.searchQuery = '',
    this.selectedPharmacyBoxId = '',
    this.selectedPharmacyBoxName = '',

    // Medicine related
    this.medicineStatus = FormzSubmissionStatus.initial,
    this.medicineErrorMessage,
    this.medicineSuccessMessage,
    this.allMedicines = const [],
    this.filteredMedicines = const [],
    this.medicineSearchQuery = '',
    this.currentPharmacyBoxId = '',
  });

  // medication tracking properties
  final DateTime? selectedExpirationDate;
  final int selectedQuantity;
  final bool shouldClearControllers;

  // Barcode Scan properties
  final MedicineEntity? scannedMedicine;
  final FormzSubmissionStatus scanStatus;
  final String? scanErrorMessage;
  final String scannedBarcode;

  // Pharmacy Box properties
  final FormzSubmissionStatus status;
  final String? errorMessage;
  final String? successMessage;
  final List<PharmacyBoxEntity> allBoxes;
  final List<PharmacyBoxEntity> filteredBoxes;
  final String searchQuery;
  final String selectedPharmacyBoxId;
  final String selectedPharmacyBoxName;

  // Medicine properties
  final FormzSubmissionStatus medicineStatus;
  final String? medicineErrorMessage;
  final String? medicineSuccessMessage;
  final List<MyMedicineEntity> allMedicines;
  final List<MyMedicineEntity> filteredMedicines;
  final String medicineSearchQuery;
  final String currentPharmacyBoxId;

  ServicesState copyWith({
    // medication tracking
    DateTime? selectedExpirationDate,
    int? selectedQuantity,
    bool? shouldClearControllers,
    bool clearScannedMedicine = false,

    // Barcode Scan parameters
    MedicineEntity? scannedMedicine,
    FormzSubmissionStatus? scanStatus,
    String? scanErrorMessage,
    String? scannedBarcode,

    // Pharmacy Box parameters
    FormzSubmissionStatus? status,
    String? errorMessage,
    String? successMessage,
    List<PharmacyBoxEntity>? allBoxes,
    List<PharmacyBoxEntity>? filteredBoxes,
    String? searchQuery,
    String? selectedPharmacyBoxId,
    String? selectedPharmacyBoxName,

    // Medicine parameters
    FormzSubmissionStatus? medicineStatus,
    String? medicineErrorMessage,
    String? medicineSuccessMessage,
    List<MyMedicineEntity>? allMedicines,
    List<MyMedicineEntity>? filteredMedicines,
    String? medicineSearchQuery,
    String? currentPharmacyBoxId,
  }) {
    return ServicesState(
      // medication tracking
      selectedExpirationDate: selectedExpirationDate ?? this.selectedExpirationDate,
      selectedQuantity: selectedQuantity ?? this.selectedQuantity,
      shouldClearControllers: shouldClearControllers ?? this.shouldClearControllers,

      // Barcode Scan - Fix the null assignment issue
      scannedMedicine: clearScannedMedicine ? null : (scannedMedicine ?? this.scannedMedicine),
      scanStatus: scanStatus ?? this.scanStatus,
      scanErrorMessage: scanErrorMessage,
      scannedBarcode: scannedBarcode ?? this.scannedBarcode,

      // Pharmacy Box
      status: status ?? this.status,
      errorMessage: errorMessage,
      successMessage: successMessage,
      allBoxes: allBoxes ?? this.allBoxes,
      filteredBoxes: filteredBoxes ?? this.filteredBoxes,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedPharmacyBoxId: selectedPharmacyBoxId ?? this.selectedPharmacyBoxId,
      selectedPharmacyBoxName: selectedPharmacyBoxName ?? this.selectedPharmacyBoxName,

      // Medicine
      medicineStatus: medicineStatus ?? this.medicineStatus,
      medicineErrorMessage: medicineErrorMessage,
      medicineSuccessMessage: medicineSuccessMessage,
      allMedicines: allMedicines ?? this.allMedicines,
      filteredMedicines: filteredMedicines ?? this.filteredMedicines,
      medicineSearchQuery: medicineSearchQuery ?? this.medicineSearchQuery,
      currentPharmacyBoxId: currentPharmacyBoxId ?? this.currentPharmacyBoxId,
    );
  }

  // ============================================
  // Convenience Getters
  // ============================================

  // Barcode Scan getters
  bool get hasScanError => scanErrorMessage != null;
  bool get isScanLoading => scanStatus == FormzSubmissionStatus.inProgress;
  bool get isScanSuccess => scanStatus == FormzSubmissionStatus.success;
  bool get isScanFailure => scanStatus == FormzSubmissionStatus.failure;
  bool get hasMedicineScanned => scannedMedicine != null;

  // Pharmacy Box getters
  bool get hasError => errorMessage != null;
  bool get hasSuccess => successMessage != null;
  bool get isLoading => status == FormzSubmissionStatus.inProgress;
  bool get isSuccess => status == FormzSubmissionStatus.success;
  bool get isFailure => status == FormzSubmissionStatus.failure;
  bool get hasPharmacyBoxes => allBoxes.isNotEmpty;
  bool get hasSelectedPharmacyBox => selectedPharmacyBoxId.isNotEmpty;

  // Medicine getters
  bool get hasMedicineError => medicineErrorMessage != null;
  bool get hasMedicineSuccess => medicineSuccessMessage != null;
  bool get isMedicineLoading => medicineStatus == FormzSubmissionStatus.inProgress;
  bool get isMedicineSuccess => medicineStatus == FormzSubmissionStatus.success;
  bool get isMedicineFailure => medicineStatus == FormzSubmissionStatus.failure;
  bool get hasMedicines => allMedicines.isNotEmpty;

  // Medication Tracking getters
  bool get hasExpirationDate => selectedExpirationDate != null;
  bool get hasQuantity => selectedQuantity > 0;
  bool get canAddMedicine => hasMedicineScanned && hasExpirationDate && hasQuantity && hasSelectedPharmacyBox;

  @override
  List<Object?> get props => [
    // medication tracking
    selectedExpirationDate,
    selectedQuantity,
    shouldClearControllers,

    // Barcode Scan
    scannedMedicine,
    scanStatus,
    scanErrorMessage,
    scannedBarcode,

    // Pharmacy Box
    status,
    errorMessage,
    successMessage,
    allBoxes,
    filteredBoxes,
    searchQuery,
    selectedPharmacyBoxId,
    selectedPharmacyBoxName,

    // Medicine
    medicineStatus,
    medicineErrorMessage,
    medicineSuccessMessage,
    allMedicines,
    filteredMedicines,
    medicineSearchQuery,
    currentPharmacyBoxId,
  ];
}