part of 'services_cubit.dart';

class ServicesState extends Equatable {
  const ServicesState({
    // Barcode Scan related - ADD THESE LINES
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
    this.selectedPharmacyBoxName = '', // ADD THIS LINE

    // Medicine related
    this.medicineStatus = FormzSubmissionStatus.initial,
    this.medicineErrorMessage,
    this.medicineSuccessMessage,
    this.allMedicines = const [],
    this.filteredMedicines = const [],
    this.medicineSearchQuery = '',
    this.currentPharmacyBoxId = '',
  });


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
  final String selectedPharmacyBoxName; // ADD THIS LINE

  // Medicine properties
  final FormzSubmissionStatus medicineStatus;
  final String? medicineErrorMessage;
  final String? medicineSuccessMessage;
  final List<MyMedicineEntity> allMedicines;
  final List<MyMedicineEntity> filteredMedicines;
  final String medicineSearchQuery;
  final String currentPharmacyBoxId;

  ServicesState copyWith({
    // Barcode Scan parameters - ADD THESE LINES
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
    String? selectedPharmacyBoxName, // ADD THIS LINE

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
      // Barcode Scan - ADD THESE LINES
      scannedMedicine: scannedMedicine,
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
      selectedPharmacyBoxName: selectedPharmacyBoxName ?? this.selectedPharmacyBoxName, // ADD THIS LINE

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
  // Barcode Scan getters - ADD THESE LINES
  bool get hasScanError => scanErrorMessage != null;
  bool get isScanLoading => scanStatus == FormzSubmissionStatus.inProgress;
  bool get isScanSuccess => scanStatus == FormzSubmissionStatus.success;
  bool get isScanFailure => scanStatus == FormzSubmissionStatus.failure;
  // Pharmacy Box getters
  bool get hasError => errorMessage != null;
  bool get hasSuccess => successMessage != null;
  bool get isLoading => status == FormzSubmissionStatus.inProgress;
  bool get isSuccess => status == FormzSubmissionStatus.success;
  bool get isFailure => status == FormzSubmissionStatus.failure;

  // Medicine getters
  bool get hasMedicineError => medicineErrorMessage != null;
  bool get hasMedicineSuccess => medicineSuccessMessage != null;
  bool get isMedicineLoading => medicineStatus == FormzSubmissionStatus.inProgress;
  bool get isMedicineSuccess => medicineStatus == FormzSubmissionStatus.success;
  bool get isMedicineFailure => medicineStatus == FormzSubmissionStatus.failure;

  @override
  List<Object?> get props => [
    // Barcode Scan - ADD THESE LINES
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
    selectedPharmacyBoxName, // ADD THIS LINE

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