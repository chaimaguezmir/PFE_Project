// lib/presentation/bloc/prescription/prescription_creation_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/prescription/disease_entity.dart';
import 'package:flutter_mobile/domain/entities/services/PharmacyBoxEntity.dart';
import 'package:flutter_mobile/domain/entities/services/my_medicine_entity.dart';
import 'package:flutter_mobile/domain/repositories/disease_repository.dart';
import 'package:flutter_mobile/domain/repositories/medicine_repository.dart';
import 'package:flutter_mobile/domain/repositories/pharmacy_repository.dart';
import 'package:formz/formz.dart';

part 'prescription_creation_state.dart';

class PrescriptionCreationCubit extends Cubit<PrescriptionCreationState> {
  PrescriptionCreationCubit(
      this._diseaseRepository,
      this._pharmacyRepository,
      this._medicineRepository,
      ) : super(const PrescriptionCreationState());

  final DiseaseRepository _diseaseRepository;
  final PharmacyRepository _pharmacyRepository;
  final MedicineRepository _medicineRepository;

  // Prescription methods
  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateSelectedDiseaseId(String? diseaseId) {
    emit(state.copyWith(selectedDiseaseId: diseaseId));
  }

  // --- Treatment form related update methods ---
  void updateTreatmentSelectedBox(String boxId) {
    // Update the treatment selected box and reset treatment medicine selection
    emit(state.copyWith(
      treatmentSelectedBox: boxId,
      treatmentSelectedMedicineId: '',
    ));
  }

  void updateTreatmentSelectedMedicineId(String medicineId) {
    emit(state.copyWith(treatmentSelectedMedicineId: medicineId));
  }

  void updateTreatmentDosage(int dosage) {
    emit(state.copyWith(treatmentSelectedDosage: dosage));
  }

  void updateTreatmentFrequency(String frequency) {
    emit(state.copyWith(treatmentSelectedFrequency: frequency));
  }

  void updateTreatmentDurationDays(int days) {
    emit(state.copyWith(treatmentSelectedDurationDays: days));
  }

  void updateTreatmentMoments(Set<String> moments) {
    emit(state.copyWith(treatmentSelectedMoments: moments));
  }

  void updateTreatmentMealTiming(String timing) {
    emit(state.copyWith(treatmentMealTiming: timing));
  }

  void updateTreatmentSearchQuery(String query) {
    emit(state.copyWith(treatmentSearchQuery: query));
  }
  // --- end treatment updates ---

  /// Builds a treatment object from current treatment fields and appends it to
  /// state.treatments. Also resets the treatment fields back to their defaults.
  void addTreatment() {
    // require the minimal data
    if (state.treatmentSelectedBox.isEmpty ||
        state.treatmentSelectedMedicineId.isEmpty) {
      return;
    }

    // Safely find box name and medicine name from existing lists without creating new entities
    String boxName = '';
    for (final b in state.pharmacyBoxes) {
      if (b.id == state.treatmentSelectedBox) {
        boxName = b.groupName;
        break;
      }
    }

    String medicineName = '';
    for (final m in state.medicines) {
      if (m.id == state.treatmentSelectedMedicineId) {
        medicineName = m.name;
        break;
      }
    }

    final newTreatment = <String, dynamic>{
      'boxId': state.treatmentSelectedBox,
      'boxName': boxName,
      'medicineId': state.treatmentSelectedMedicineId,
      'medicineName': medicineName,
      'dosage': state.treatmentSelectedDosage,
      'frequency': state.treatmentSelectedFrequency,
      'durationDays': state.treatmentSelectedDurationDays,
      'moments': state.treatmentSelectedMoments.toList(),
      'mealTiming': state.treatmentMealTiming,
      'searchQuery': state.treatmentSearchQuery,
      'createdAt': DateTime.now().toIso8601String(),
    };

    final updatedList = List<Map<String, dynamic>>.from(state.treatments)
      ..add(newTreatment);

    // Append and reset treatment fields
    emit(state.copyWith(
      treatments: updatedList,
      treatmentSelectedBox: '',
      treatmentSelectedMedicineId: '',
      treatmentSelectedDosage: 1,
      treatmentSelectedFrequency: 'Chaque jour',
      treatmentSelectedDurationDays: 30,
      treatmentSelectedMoments: const {'Matin', 'Après Midi'},
      treatmentMealTiming: 'Avant repas',
      treatmentSearchQuery: '',
    ));
  }

  /// Optionally remove a treatment by index
  void removeTreatmentAt(int index) {
    if (index < 0 || index >= state.treatments.length) return;
    final updated = List<Map<String, dynamic>>.from(state.treatments)
      ..removeAt(index);
    emit(state.copyWith(treatments: updated));
  }

  Future<void> fetchDiseases() async {
    emit(state.copyWith(diseasesStatus: FormzSubmissionStatus.inProgress));

    try {
      final result = await _diseaseRepository.getDiseases();

      if (result is DataSuccess<List<DiseaseEntity>>) {
        emit(
          state.copyWith(
            diseasesStatus: FormzSubmissionStatus.success,
            diseases: result.data ?? [],
          ),
        );
      } else {
        emit(
          state.copyWith(
            diseasesStatus: FormzSubmissionStatus.failure,
            diseasesErrorMessage: result.error ?? 'Failed to load diseases',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          diseasesStatus: FormzSubmissionStatus.failure,
          diseasesErrorMessage: 'Unexpected error: $e',
        ),
      );
    }
  }

  Future<void> fetchPharmacyBoxes() async {
    emit(state.copyWith(pharmacyBoxesStatus: FormzSubmissionStatus.inProgress));

    try {
      final result = await _pharmacyRepository.getMyPharmacyBoxes();

      if (result is DataSuccess<List<PharmacyBoxEntity>>) {
        emit(
          state.copyWith(
            pharmacyBoxesStatus: FormzSubmissionStatus.success,
            pharmacyBoxes: result.data ?? [],
          ),
        );
      } else {
        emit(
          state.copyWith(
            pharmacyBoxesStatus: FormzSubmissionStatus.failure,
            pharmacyBoxesErrorMessage: result.error ?? 'Failed to load pharmacy boxes',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          pharmacyBoxesStatus: FormzSubmissionStatus.failure,
          pharmacyBoxesErrorMessage: 'Unexpected error: $e',
        ),
      );
    }
  }

  void selectPharmacyBox(String boxId) {
    emit(state.copyWith(
      selectedPharmacyBoxId: boxId,
      medicines: [],
      selectedMedicineId: null,
    ));
    fetchMedicinesForBox(boxId);
  }

  Future<void> fetchMedicinesForBox(String boxId) async {
    emit(state.copyWith(medicinesStatus: FormzSubmissionStatus.inProgress));

    try {
      final result = await _medicineRepository.getMyMedicines(boxId);

      if (result is DataSuccess<List<MyMedicineEntity>>) {
        final medicines = result.data ?? [];

        emit(
          state.copyWith(
            medicinesStatus: FormzSubmissionStatus.success,
            medicines: medicines,
          ),
        );
      } else {
        emit(
          state.copyWith(
            medicinesStatus: FormzSubmissionStatus.failure,
            medicinesErrorMessage: result.error ?? 'Failed to load medicines',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          medicinesStatus: FormzSubmissionStatus.failure,
          medicinesErrorMessage: 'Unexpected error: $e',
        ),
      );
    }
  }

  void selectMedicine(String medicineId) {
    emit(state.copyWith(selectedMedicineId: medicineId));
  }

  // Clear medicines when no box is selected
  void clearMedicines() {
    emit(
      state.copyWith(
        medicines: [],
        selectedMedicineId: null,
        medicinesStatus: FormzSubmissionStatus.initial,
      ),
    );
  }
}