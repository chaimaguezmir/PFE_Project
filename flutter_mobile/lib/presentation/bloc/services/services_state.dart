part of 'services_cubit.dart';

class ServicesState extends Equatable {
  const ServicesState({
    // ============================================
    // Medicine Search Properties (by name)
    // ============================================
    this.searchQuery = '',
    this.searchResults = const [],
    this.searchStatus = FormzSubmissionStatus.initial,
    this.searchErrorMessage,

    // Selected medicine from search
    this.selectedMedicine,
    this.selectedMedicineName = '',
    this.selectedMedicineForm = '',
    this.selectedQuantity = 0,
    this.selectedExpirationDate,

    // ============================================
    // Barcode Scan Properties
    // ============================================
    this.scannedMedicine,
    this.scanStatus = FormzSubmissionStatus.initial,
    this.scanErrorMessage,
    this.scannedBarcode = '',

    // Scanned medicine tracking
    this.scannedMedicineQuantity = 0,
    this.scannedMedicineExpirationDate,
    this.shouldClearControllers = false,

    // ============================================
    // Pharmacy Box Properties
    // ============================================
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.allBoxes = const [],
    this.filteredBoxes = const [],
    this.boxSearchQuery = '',
    this.selectedPharmacyBoxId = '',
    this.selectedPharmacyBoxName = '',

    // ============================================
    // Medicine Management Properties (in pharmacy box)
    // ============================================
    this.medicineStatus = FormzSubmissionStatus.initial,
    this.medicineErrorMessage,
    this.medicineSuccessMessage,
    this.allMedicines = const [],
    this.filteredMedicines = const [],
    this.medicineSearchQuery = '',
    this.currentPharmacyBoxId = '',

    // ============================================
    // Purchase History Properties
    // ============================================
    this.purchaseHistoryStatus = FormzSubmissionStatus.initial,
    this.purchaseHistoryErrorMessage,
    this.purchaseHistoryList = const [],
  });

  // ============================================
  // Medicine Search Properties (by name)
  // ============================================
  final String searchQuery;
  final List<MedicineEntity> searchResults;
  final FormzSubmissionStatus searchStatus;
  final String? searchErrorMessage;

  // Selected medicine from search
  final MedicineEntity? selectedMedicine;
  final String selectedMedicineName;
  final String selectedMedicineForm;
  final int selectedQuantity;
  final DateTime? selectedExpirationDate;

  // ============================================
  // Barcode Scan Properties
  // ============================================
  final MedicineEntity? scannedMedicine;
  final FormzSubmissionStatus scanStatus;
  final String? scanErrorMessage;
  final String scannedBarcode;

  // Scanned medicine tracking
  final int scannedMedicineQuantity;
  final DateTime? scannedMedicineExpirationDate;
  final bool shouldClearControllers;

  // ============================================
  // Pharmacy Box Properties
  // ============================================
  final FormzSubmissionStatus status;
  final String? errorMessage;
  final String? successMessage;
  final List<PharmacyBoxEntity> allBoxes;
  final List<PharmacyBoxEntity> filteredBoxes;
  final String boxSearchQuery;
  final String selectedPharmacyBoxId;
  final String selectedPharmacyBoxName;

  // ============================================
  // Medicine Management Properties (in pharmacy box)
  // ============================================
  final FormzSubmissionStatus medicineStatus;
  final String? medicineErrorMessage;
  final String? medicineSuccessMessage;
  final List<MyMedicineEntity> allMedicines;
  final List<MyMedicineEntity> filteredMedicines;
  final String medicineSearchQuery;
  final String currentPharmacyBoxId;

  // ============================================
  // Purchase History Properties
  // ============================================
  final FormzSubmissionStatus purchaseHistoryStatus;
  final String? purchaseHistoryErrorMessage;
  final List<PurchaseHistoryEntity> purchaseHistoryList;

  // ============================================
  // Copy With Method
  // ============================================
  ServicesState copyWith({
    // Medicine Search parameters (by name)
    String? searchQuery,
    List<MedicineEntity>? searchResults,
    FormzSubmissionStatus? searchStatus,
    String? searchErrorMessage,

    // Selected medicine parameters
    MedicineEntity? selectedMedicine,
    String? selectedMedicineName,
    String? selectedMedicineForm,
    int? selectedQuantity,
    DateTime? selectedExpirationDate,

    // Barcode Scan parameters
    MedicineEntity? scannedMedicine,
    FormzSubmissionStatus? scanStatus,
    String? scanErrorMessage,
    String? scannedBarcode,
    bool clearScannedMedicine = false,

    // Scanned medicine tracking
    int? scannedMedicineQuantity,
    DateTime? scannedMedicineExpirationDate,
    bool clearScannedMedicineExpirationDate = false, // Add this flag
    bool? shouldClearControllers,

    // Pharmacy Box parameters
    FormzSubmissionStatus? status,
    String? errorMessage,
    String? successMessage,
    List<PharmacyBoxEntity>? allBoxes,
    List<PharmacyBoxEntity>? filteredBoxes,
    String? boxSearchQuery,
    String? selectedPharmacyBoxId,
    String? selectedPharmacyBoxName,

    // Medicine Management parameters
    FormzSubmissionStatus? medicineStatus,
    String? medicineErrorMessage,
    String? medicineSuccessMessage,
    List<MyMedicineEntity>? allMedicines,
    List<MyMedicineEntity>? filteredMedicines,
    String? medicineSearchQuery,
    String? currentPharmacyBoxId,

    // Purchase History parameters
    FormzSubmissionStatus? purchaseHistoryStatus,
    String? purchaseHistoryErrorMessage,
    List<PurchaseHistoryEntity>? purchaseHistoryList,
  }) {
    return ServicesState(
      // Medicine Search assignments
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      searchStatus: searchStatus ?? this.searchStatus,
      searchErrorMessage: searchErrorMessage,

      // Selected medicine assignments
      selectedMedicine: selectedMedicine,
      selectedMedicineName: selectedMedicineName ?? this.selectedMedicineName,
      selectedMedicineForm: selectedMedicineForm ?? this.selectedMedicineForm,
      selectedQuantity: selectedQuantity ?? this.selectedQuantity,
      selectedExpirationDate: selectedExpirationDate,

      // Barcode Scan assignments
      scannedMedicine: clearScannedMedicine ? null : (scannedMedicine ?? this.scannedMedicine),
      scanStatus: scanStatus ?? this.scanStatus,
      scanErrorMessage: scanErrorMessage,
      scannedBarcode: scannedBarcode ?? this.scannedBarcode,

      // Scanned medicine tracking assignments - FIXED
      scannedMedicineQuantity: scannedMedicineQuantity ?? this.scannedMedicineQuantity,
      scannedMedicineExpirationDate: clearScannedMedicineExpirationDate
          ? null
          : (scannedMedicineExpirationDate ?? this.scannedMedicineExpirationDate),
      shouldClearControllers: shouldClearControllers ?? this.shouldClearControllers,

      // Pharmacy Box assignments
      status: status ?? this.status,
      errorMessage: errorMessage,
      successMessage: successMessage,
      allBoxes: allBoxes ?? this.allBoxes,
      filteredBoxes: filteredBoxes ?? this.filteredBoxes,
      boxSearchQuery: boxSearchQuery ?? this.boxSearchQuery,
      selectedPharmacyBoxId: selectedPharmacyBoxId ?? this.selectedPharmacyBoxId,
      selectedPharmacyBoxName: selectedPharmacyBoxName ?? this.selectedPharmacyBoxName,

      // Medicine Management assignments
      medicineStatus: medicineStatus ?? this.medicineStatus,
      medicineErrorMessage: medicineErrorMessage,
      medicineSuccessMessage: medicineSuccessMessage,
      allMedicines: allMedicines ?? this.allMedicines,
      filteredMedicines: filteredMedicines ?? this.filteredMedicines,
      medicineSearchQuery: medicineSearchQuery ?? this.medicineSearchQuery,
      currentPharmacyBoxId: currentPharmacyBoxId ?? this.currentPharmacyBoxId,

      // Purchase History assignments
      purchaseHistoryStatus: purchaseHistoryStatus ?? this.purchaseHistoryStatus,
      purchaseHistoryErrorMessage: purchaseHistoryErrorMessage,
      purchaseHistoryList: purchaseHistoryList ?? this.purchaseHistoryList,
    );
  }
  // ============================================
  // Medicine Search Convenience Getters
  // ============================================
  bool get isSearching => searchStatus == FormzSubmissionStatus.inProgress;
  bool get isSearchSuccess => searchStatus == FormzSubmissionStatus.success;
  bool get isSearchFailure => searchStatus == FormzSubmissionStatus.failure;
  bool get hasSearchResults => searchResults.isNotEmpty;
  bool get hasSearchError => searchErrorMessage != null;
  bool get hasMedicineSelected => selectedMedicine != null;
  bool get canAddMedicine => hasMedicineSelected &&
      selectedQuantity > 0 &&
      selectedExpirationDate != null &&
      selectedPharmacyBoxId.isNotEmpty;

  // ============================================
  // Barcode Scan Convenience Getters
  // ============================================
  bool get hasScanError => scanErrorMessage != null;
  bool get isScanLoading => scanStatus == FormzSubmissionStatus.inProgress;
  bool get isScanSuccess => scanStatus == FormzSubmissionStatus.success;
  bool get isScanFailure => scanStatus == FormzSubmissionStatus.failure;
  bool get hasMedicineScanned => scannedMedicine != null;
  bool get hasScannedExpirationDate => scannedMedicineExpirationDate != null;
  bool get hasScannedQuantity => scannedMedicineQuantity > 0;
  bool get canAddScannedMedicine => hasMedicineScanned &&
      hasScannedExpirationDate &&
      hasScannedQuantity &&
      hasSelectedPharmacyBox;

  // ============================================
  // Pharmacy Box Convenience Getters
  // ============================================
  bool get hasError => errorMessage != null;
  bool get hasSuccess => successMessage != null;
  bool get isLoading => status == FormzSubmissionStatus.inProgress;
  bool get isSuccess => status == FormzSubmissionStatus.success;
  bool get isFailure => status == FormzSubmissionStatus.failure;
  bool get hasPharmacyBoxes => allBoxes.isNotEmpty;
  bool get hasSelectedPharmacyBox => selectedPharmacyBoxId.isNotEmpty;

  // ============================================
  // Medicine Management Convenience Getters
  // ============================================
  bool get hasMedicineError => medicineErrorMessage != null;
  bool get hasMedicineSuccess => medicineSuccessMessage != null;
  bool get isMedicineLoading => medicineStatus == FormzSubmissionStatus.inProgress;
  bool get isMedicineSuccess => medicineStatus == FormzSubmissionStatus.success;
  bool get isMedicineFailure => medicineStatus == FormzSubmissionStatus.failure;
  bool get hasMedicines => allMedicines.isNotEmpty;

  // ============================================
  // Purchase History Convenience Getters
  // ============================================
  bool get hasPurchaseHistoryError => purchaseHistoryErrorMessage != null;
  bool get isPurchaseHistoryLoading => purchaseHistoryStatus == FormzSubmissionStatus.inProgress;
  bool get isPurchaseHistorySuccess => purchaseHistoryStatus == FormzSubmissionStatus.success;
  bool get isPurchaseHistoryFailure => purchaseHistoryStatus == FormzSubmissionStatus.failure;
  bool get hasPurchaseHistory => purchaseHistoryList.isNotEmpty;

  // ============================================
  // General Convenience Getters
  // ============================================
  bool get hasAnyLoading => isLoading || isMedicineLoading || isScanLoading || isSearching || isPurchaseHistoryLoading;
  bool get hasAnyError => hasError || hasMedicineError || hasScanError || hasSearchError || hasPurchaseHistoryError;

  // ============================================
  // Equals and Props
  // ============================================
  @override
  List<Object?> get props => [
    // Medicine Search props
    searchQuery,
    searchResults,
    searchStatus,
    searchErrorMessage,

    // Selected medicine props
    selectedMedicine,
    selectedMedicineName,
    selectedMedicineForm,
    selectedQuantity,
    selectedExpirationDate,

    // Barcode Scan props
    scannedMedicine,
    scanStatus,
    scanErrorMessage,
    scannedBarcode,

    // Scanned medicine tracking props
    scannedMedicineQuantity,
    scannedMedicineExpirationDate,
    shouldClearControllers,

    // Pharmacy Box props
    status,
    errorMessage,
    successMessage,
    allBoxes,
    filteredBoxes,
    boxSearchQuery,
    selectedPharmacyBoxId,
    selectedPharmacyBoxName,

    // Medicine Management props
    medicineStatus,
    medicineErrorMessage,
    medicineSuccessMessage,
    allMedicines,
    filteredMedicines,
    medicineSearchQuery,
    currentPharmacyBoxId,

    // Purchase History props
    purchaseHistoryStatus,
    purchaseHistoryErrorMessage,
    purchaseHistoryList,
  ];
}