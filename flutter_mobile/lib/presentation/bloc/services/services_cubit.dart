import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/services/PharmacyBoxEntity.dart';
import 'package:flutter_mobile/domain/entities/services/medicine_entity.dart';
import 'package:flutter_mobile/domain/entities/services/my_medicine_entity.dart';
import 'package:flutter_mobile/domain/repositories/medicine_repository.dart';
import 'package:flutter_mobile/domain/repositories/pharmacy_repository.dart';
import 'package:formz/formz.dart';

part 'services_state.dart';

/// ServicesCubit handles all services-related functionality including:
/// - Medicine search by name
/// - Barcode scanning and medicine detection
/// - Pharmacy box management
/// - Medicine management within pharmacy boxes
/// - Medication tracking (quantities and expiration dates)
class ServicesCubit extends Cubit<ServicesState> {
  ServicesCubit(this._pharmacyRepository, this._medicineRepository)
      : super(const ServicesState());

  final PharmacyRepository _pharmacyRepository;
  final MedicineRepository _medicineRepository;

  // Debounce timer for search
  Timer? _searchTimer;

  // ============================================
  // Medicine Search Methods
  // ============================================

  /// Search medicines by name with debouncing
  void searchMedicinesByName(String query) async {
    // Cancel previous timer
    _searchTimer?.cancel();

    // Clear results if query is empty
    if (query.trim().isEmpty) {
      emit(state.copyWith(
        searchResults: [],
        searchQuery: '',
        searchStatus: FormzSubmissionStatus.initial,
        searchErrorMessage: null,
      ));
      return;
    }

    // Update search query immediately for UI feedback
    emit(state.copyWith(
      searchQuery: query,
      searchStatus: FormzSubmissionStatus.inProgress,
      searchErrorMessage: null,
    ));

    // Debounce the API call
    _searchTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final result = await _medicineRepository.searchMedicinesByName(query.trim());

        if (result is DataSuccess<List<MedicineEntity>>) {
          emit(state.copyWith(
            searchResults: result.data ?? [],
            searchStatus: FormzSubmissionStatus.success,
            searchErrorMessage: null,
          ));
        } else {
          emit(state.copyWith(
            searchStatus: FormzSubmissionStatus.failure,
            searchErrorMessage: result.error ?? 'Failed to search medicines',
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          searchStatus: FormzSubmissionStatus.failure,
          searchErrorMessage: 'An error occurred during search: $e',
        ));
      }
    });
  }

  /// Select a medicine from search results
  void selectMedicineFromSearch(MedicineEntity medicine) {
    emit(state.copyWith(
      selectedMedicine: medicine,
      selectedMedicineName: medicine.name,
      selectedMedicineForm: medicine.dosageForm,
    ));
  }

  /// Clear search results and selected medicine
  void clearSearch() {
    _searchTimer?.cancel();
    emit(state.copyWith(
      searchResults: [],
      searchQuery: '',
      selectedMedicine: null,
      selectedMedicineName: '',
      selectedMedicineForm: '',
      selectedQuantity: 0,
      selectedExpirationDate: null,
      searchStatus: FormzSubmissionStatus.initial,
      searchErrorMessage: null,
    ));
  }

  /// Set quantity for selected medicine
  void setSelectedQuantity(int quantity) {
    emit(state.copyWith(selectedQuantity: quantity));
  }

  /// Set expiration date for selected medicine
  void setSelectedExpirationDate(DateTime date) {
    emit(state.copyWith(selectedExpirationDate: date));
  }

  /// Add selected medicine to pharmacy box
  Future<void> addSelectedMedicineToPharmacyBox() async {
    if (state.selectedMedicine == null ||
        state.selectedQuantity <= 0 ||
        state.selectedExpirationDate == null ||
        state.selectedPharmacyBoxId.isEmpty) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Please fill all required fields',
      ));
      return;
    }

    emit(state.copyWith(
      status: FormzSubmissionStatus.inProgress,
      errorMessage: null,
    ));

    try {
      // Check if medicine already exists in pharmacy box
      final checkResult = await _medicineRepository.checkMyMedicine(
        state.selectedPharmacyBoxId,
        state.selectedMedicine!.id,
      );

      String myMedicineId;

      if (checkResult is DataSuccess && checkResult.data != null) {
        // Medicine already exists
        myMedicineId = checkResult.data!.id;
      } else {
        // Create new medicine entry
        final addMedicineResult = await _medicineRepository.addMyMedicine(
          pharmacyBoxId: state.selectedPharmacyBoxId,
          medicineId: state.selectedMedicine!.id,
          name: state.selectedMedicine!.name,
          form: state.selectedMedicine!.dosageForm,
        );

        if (addMedicineResult is DataSuccess) {
          myMedicineId = addMedicineResult.data!.id;
        } else {
          throw Exception(addMedicineResult.error ?? 'Failed to add medicine');
        }
      }

      // Add purchase history
      final purchaseResult = await _medicineRepository.addPurchaseHistory(
        myMedicineId: myMedicineId,
        quantityPurchased: state.selectedQuantity,
        expiryDate: state.selectedExpirationDate!,
      );

      if (purchaseResult is DataSuccess) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          successMessage: 'Medicine added successfully!',
        ));

        // Clear form after success
        clearSearch();

        // Refresh pharmacy box medicines if needed
        if (state.selectedPharmacyBoxId.isNotEmpty) {
          await fetchMedicines(state.selectedPharmacyBoxId);
        }
      } else {
        throw Exception(purchaseResult.error ?? 'Failed to add purchase history');
      }
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Error adding medicine: $e',
      ));
    }
  }

  // ============================================
  // Barcode Scanning Methods
  // ============================================

  /// Fetch medicine data by scanning a barcode
  /// Sets loading state, calls repository, and handles success/error
  Future<void> fetchMedicineByBarcode(String barcode) async {
    emit(state.copyWith(
      scanStatus: FormzSubmissionStatus.inProgress,
      scanErrorMessage: null,
      scannedBarcode: barcode,
    ));

    final result = await _medicineRepository.getMedicineByBarcode(barcode);

    if (result is DataSuccess<MedicineEntity>) {
      emit(state.copyWith(
        scannedMedicine: result.data,
        scanStatus: FormzSubmissionStatus.success,
        scanErrorMessage: null,
      ));
    } else {
      emit(state.copyWith(
        scanStatus: FormzSubmissionStatus.failure,
        scanErrorMessage: result.error ?? 'Médicament non trouvé',
      ));
    }
  }

  /// Clear all scanned medicine data and reset scan state
  void clearScannedMedicine() {
    emit(state.copyWith(
      clearScannedMedicine: true,
      scannedBarcode: '',
      scanStatus: FormzSubmissionStatus.initial,
      scanErrorMessage: null,
      // Use the new flag to properly clear the expiration date
      clearScannedMedicineExpirationDate: true,
      scannedMedicineQuantity: 0,
      shouldClearControllers: true,
    ));
  }

  // ============================================
  // Pharmacy Box Management Methods
  // ============================================

  /// Fetch all user's pharmacy boxes from the server
  Future<void> fetchPharmacyBoxes() async {
    if (isClosed) return; // Avoid emitting if cubit is closed

    emit(state.copyWith(
      status: FormzSubmissionStatus.inProgress,
      errorMessage: null,
    ));

    final result = await _pharmacyRepository.getMyPharmacyBoxes();

    if (isClosed) return; // Check again after async call

    if (result is DataSuccess<List<PharmacyBoxEntity>>) {
      final boxes = result.data ?? [];
      emit(state.copyWith(
        allBoxes: boxes,
        filteredBoxes: boxes,
        status: FormzSubmissionStatus.success,
        errorMessage: null,
      ));
    } else {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: result.error ?? 'Failed to fetch pharmacy boxes',
      ));
    }
  }

  /// Select a pharmacy box and automatically fetch its medicines
  Future<void> selectPharmacyBoxAndFetchMedicines(String pharmacyBoxId) async {
    // First update the selected pharmacy box ID
    emit(state.copyWith(selectedPharmacyBoxId: pharmacyBoxId));

    // Then automatically fetch medicines for this box
    await fetchMedicines(pharmacyBoxId);
  }

  /// Select pharmacy box by ID without fetching medicines
  void selectPharmacyBoxId(String uuid) {
    emit(state.copyWith(selectedPharmacyBoxId: uuid));
  }

  /// Select pharmacy box by name for display purposes
  void selectPharmacyBoxName(String name) {
    emit(state.copyWith(selectedPharmacyBoxName: name));
  }

  /// Get the selected pharmacy box entity from the list
  PharmacyBoxEntity? getSelectedPharmacyBox() {
    if (state.selectedPharmacyBoxId.isEmpty) return null;

    try {
      return state.allBoxes.firstWhere(
              (box) => box.id == state.selectedPharmacyBoxId
      );
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // Pharmacy Box Search Methods
  // ============================================

  /// Filter pharmacy boxes based on search query
  void searchBoxes(String query, List<PharmacyBoxEntity> allBoxes) {
    if (query.isEmpty) {
      emit(state.copyWith(filteredBoxes: allBoxes, boxSearchQuery: query));
      return;
    }

    final filteredBoxes = allBoxes
        .where((box) => box.groupName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(state.copyWith(filteredBoxes: filteredBoxes, boxSearchQuery: query));
  }



  /// Clear pharmacy box search and reset to all boxes
  void clearBoxSearch() {
    emit(state.copyWith(filteredBoxes: state.allBoxes, boxSearchQuery: ''));
  }

  // ============================================
  // Medicine Management Methods
  // ============================================

  /// Fetch medicines for a specific pharmacy box
  Future<void> fetchMedicines(String pharmacyBoxId) async {
    emit(state.copyWith(
      medicineStatus: FormzSubmissionStatus.inProgress,
      medicineErrorMessage: null,
      currentPharmacyBoxId: pharmacyBoxId,
    ));

    final result = await _medicineRepository.getMyMedicines(pharmacyBoxId);

    if (result is DataSuccess<List<MyMedicineEntity>>) {
      final medicines = result.data ?? [];
      emit(state.copyWith(
        allMedicines: medicines,
        filteredMedicines: medicines,
        medicineStatus: FormzSubmissionStatus.success,
        medicineErrorMessage: null,
      ));
    } else {
      emit(state.copyWith(
        medicineStatus: FormzSubmissionStatus.failure,
        medicineErrorMessage: result.error ?? 'Failed to fetch medicines',
      ));
    }
  }

  /// Refresh medicines for the currently selected pharmacy box
  Future<void> refreshCurrentMedicines() async {
    if (state.selectedPharmacyBoxId.isNotEmpty) {
      await fetchMedicines(state.selectedPharmacyBoxId);
    }
  }

  /// Clear all medicine data (useful when navigating away)
  void clearMedicineData() {
    emit(state.copyWith(
      allMedicines: [],
      filteredMedicines: [],
      medicineSearchQuery: '',
      medicineStatus: FormzSubmissionStatus.initial,
      medicineErrorMessage: null,
      medicineSuccessMessage: null,
    ));
  }

  // ============================================
  // Medicine Search Methods (for pharmacy box)
  // ============================================

  /// Filter medicines based on search query (name, manufacturer, dosage form)
  void searchMedicines(String query, List<MyMedicineEntity> allMedicines) {
    if (query.isEmpty) {
      emit(state.copyWith(filteredMedicines: allMedicines, medicineSearchQuery: query));
      return;
    }

    final filteredMedicines = allMedicines
        .where((medicine) =>
    medicine.name.toLowerCase().contains(query.toLowerCase()) ||
        medicine.manufacturerName.toLowerCase().contains(query.toLowerCase()) ||
        medicine.dosageForm.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(state.copyWith(filteredMedicines: filteredMedicines, medicineSearchQuery: query));
  }



  /// Clear medicine search and reset to all medicines
  void clearMedicineSearch() {
    emit(state.copyWith(filteredMedicines: state.allMedicines, medicineSearchQuery: ''));
  }

  // ============================================
  // Medication Tracking Methods (for barcode scan)
  // ============================================

  /// Set expiration date for the medicine being added
  void setExpirationDate(DateTime date) {
    print('ServicesCubit.setExpirationDate called with: $date');
    print('Current state before: scannedMedicineExpirationDate = ${state.scannedMedicineExpirationDate}');

    emit(state.copyWith(scannedMedicineExpirationDate: date));

    print('New state after: scannedMedicineExpirationDate = ${state.scannedMedicineExpirationDate}');
  }

  /// Set quantity for the medicine being added
  void setQuantity(int quantity) {
    emit(state.copyWith(scannedMedicineQuantity: quantity));
  }

  /// Clear all medication tracking data (expiration date and quantity)
  void clearMedicationTrackingData() {
    emit(state.copyWith(
      clearScannedMedicineExpirationDate: true,
      scannedMedicineQuantity: 0,
    ));
  }

  // ============================================
  // Medicine Addition Methods (for barcode scan)
  // ============================================

  /// Add medicine to pharmacy box with tracking information
  /// This method handles the complete flow:
  /// 1. Check if medicine already exists in the pharmacy box
  /// 2. If not, create new MyMedicine entry
  /// 3. Add purchase history with quantity and expiration date
  Future<void> addMedicineToPharmacyBox({
    required String medicineId,
    required int quantity,
    required DateTime expirationDate,
    required String pharmacyBoxId,
  }) async {
    emit(state.copyWith(
      status: FormzSubmissionStatus.inProgress,
      errorMessage: null,
    ));

    try {
      // Step 1: Check if medicine already exists in pharmacy box
      final checkResult = await _medicineRepository.checkMyMedicine(
        pharmacyBoxId,
        medicineId,
      );

      String myMedicineId;

      if (checkResult is DataSuccess && checkResult.data != null) {
        // Medicine already exists, use existing ID
        myMedicineId = checkResult.data!.id;
        print('Medicine already exists with ID: $myMedicineId');
      } else {
        // Step 2: Medicine doesn't exist, create new MyMedicine entry
        if (state.scannedMedicine == null) {
          throw Exception('No scanned medicine data available');
        }

        final addMedicineResult = await _medicineRepository.addMyMedicine(
          pharmacyBoxId: pharmacyBoxId,
          medicineId: medicineId,
          name: state.scannedMedicine!.name,
          form: state.scannedMedicine!.dosageForm,
        );

        if (addMedicineResult is DataSuccess) {
          myMedicineId = addMedicineResult.data!.id;
          print('New medicine created with ID: $myMedicineId');
        } else {
          throw Exception(addMedicineResult.error ?? 'Failed to add medicine');
        }
      }

      // Step 3: Add purchase history with quantity and expiration date
      final purchaseHistoryResult = await _medicineRepository.addPurchaseHistory(
        myMedicineId: myMedicineId,
        quantityPurchased: quantity,
        expiryDate: expirationDate,
      );

      if (purchaseHistoryResult is DataSuccess) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          successMessage: 'Médicament ajouté avec succès',
        ));

        // Clear tracking data after successful addition
        clearMedicationTrackingData();

        // Refresh the medicines list for the current pharmacy box
        if (state.selectedPharmacyBoxId.isNotEmpty) {
          await fetchMedicines(state.selectedPharmacyBoxId);
        }
      } else {
        throw Exception(purchaseHistoryResult.error ?? 'Failed to add purchase history');
      }
    } catch (e) {
      print('Error adding medicine to pharmacy box: $e');
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Erreur lors de l\'ajout du médicament: $e',
      ));
    }
  }

  /// Convenience method to add medicine using current state values
  /// Validates all required fields before making API calls
  Future<void> addCurrentMedicineToCurrentBox() async {
    if (state.scannedMedicine == null) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Aucun médicament sélectionné',
      ));
      return;
    }

    if (state.selectedPharmacyBoxId.isEmpty) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Aucune boîte de pharmacie sélectionnée',
      ));
      return;
    }

    if (state.scannedMedicineExpirationDate == null) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Date d\'expiration requise',
      ));
      return;
    }

    if (state.scannedMedicineQuantity <= 0) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Quantité invalide',
      ));
      return;
    }

    await addMedicineToPharmacyBox(
      medicineId: state.scannedMedicine!.id,
      quantity: state.scannedMedicineQuantity,
      expirationDate: state.scannedMedicineExpirationDate!,
      pharmacyBoxId: state.selectedPharmacyBoxId,
    );
  }

  // ============================================
  // General Utility Methods
  // ============================================

  /// Clear general error messages
  void clearError() {
    emit(state.copyWith(errorMessage: null, medicineErrorMessage: null));
  }

  /// Clear all scan-related error messages
  void clearScanError() {
    emit(state.copyWith(scanErrorMessage: null));
  }

  /// Reset entire state to initial values (useful for logout or major navigation)
  void resetState() {
    emit(const ServicesState());
  }

  @override
  Future<void> close() {
    _searchTimer?.cancel();
    return super.close();
  }
}