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

class ServicesCubit extends Cubit<ServicesState> {
  ServicesCubit(this._pharmacyRepository, this._medicineRepository)
      : super(const ServicesState());

  final PharmacyRepository _pharmacyRepository;
  final MedicineRepository _medicineRepository;

  // ============================================
  // Barcode Scanning Methods
  // ============================================

  /// Fetch medicine data by barcode
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

  /// Clear scanned medicine data
  void clearScannedMedicine() {
    emit(state.copyWith(
      scannedMedicine: null,
      scannedBarcode: '',
      scanStatus: FormzSubmissionStatus.initial,
      scanErrorMessage: null,
    ));
  }


  // ============================================
  // Pharmacy Box Methods
  // ============================================

  /// Selects a pharmacy box and automatically fetches its medicines
  Future<void> selectPharmacyBoxAndFetchMedicines(String pharmacyBoxId) async {
    // First update the selected pharmacy box ID
    emit(state.copyWith(selectedPharmacyBoxId: pharmacyBoxId));

    // Then automatically fetch medicines for this box
    await fetchMedicines(pharmacyBoxId);
  }

  /// Just select pharmacy box without fetching (if needed)
  void selectPharmacyBoxId(String uuid) {
    emit(state.copyWith(selectedPharmacyBoxId: uuid));
  }
  void selectPharmacyBoxName( String name) {
    emit(state.copyWith(
      selectedPharmacyBoxName: name,
    ));
  }

  void searchBoxes(String query, List<PharmacyBoxEntity> allBoxes) {
    if (query.isEmpty) {
      emit(state.copyWith(filteredBoxes: allBoxes, searchQuery: query));
      return;
    }

    final filteredBoxes = allBoxes
        .where((box) => box.groupName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(state.copyWith(filteredBoxes: filteredBoxes, searchQuery: query));
  }

  void resetSearch(List<PharmacyBoxEntity> allBoxes) {
    emit(state.copyWith(filteredBoxes: allBoxes, searchQuery: ''));
  }

  void clearSearch() {
    emit(state.copyWith(filteredBoxes: state.allBoxes, searchQuery: ''));
  }

  Future<void> fetchPharmacyBoxes() async {
    emit(state.copyWith(
      status: FormzSubmissionStatus.inProgress,
      errorMessage: null,
    ));

    final result = await _pharmacyRepository.getMyPharmacyBoxes();

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

  // ============================================
  // Medicine Methods
  // ============================================
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

  void resetMedicineSearch(List<MyMedicineEntity> allMedicines) {
    emit(state.copyWith(filteredMedicines: allMedicines, medicineSearchQuery: ''));
  }

  void clearMedicineSearch() {
    emit(state.copyWith(filteredMedicines: state.allMedicines, medicineSearchQuery: ''));
  }

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

  void clearError() {
    emit(state.copyWith(errorMessage: null, medicineErrorMessage: null));
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
}