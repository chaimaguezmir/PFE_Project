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

  Future<void> fetchDiseases() async {
    if (_diseaseRepository == null) {
      print('Disease repository is not available');
      return;
    }

    emit(state.copyWith(diseasesStatus: FormzSubmissionStatus.inProgress));

    try {
      final result = await _diseaseRepository!.getDiseases();

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
        print('Successfully fetched ${result.data?.length ?? 0} pharmacy boxes');
        emit(
          state.copyWith(
            pharmacyBoxesStatus: FormzSubmissionStatus.success,
            pharmacyBoxes: result.data ?? [],
          ),
        );
      } else {
        print('Failed to fetch pharmacy boxes: ${result.error}');
        emit(
          state.copyWith(
            pharmacyBoxesStatus: FormzSubmissionStatus.failure,
            pharmacyBoxesErrorMessage: result.error ?? 'Failed to load pharmacy boxes',
          ),
        );
      }
    } catch (e) {
      print('Exception while fetching pharmacy boxes: $e');
      emit(
        state.copyWith(
          pharmacyBoxesStatus: FormzSubmissionStatus.failure,
          pharmacyBoxesErrorMessage: 'Unexpected error: $e',
        ),
      );
    }
  }

  void selectPharmacyBox(String boxId) {
    print('Selecting pharmacy box: $boxId');
    emit(state.copyWith(
      selectedPharmacyBoxId: boxId,
      medicines: [],
      selectedMedicineId: null,
    ));
    fetchMedicinesForBox(boxId);
  }

  Future<void> fetchMedicinesForBox(String boxId) async {
    print('Fetching medicines for pharmacy box: $boxId');
    emit(state.copyWith(medicinesStatus: FormzSubmissionStatus.inProgress));

    try {
      final result = await _medicineRepository.getMyMedicines(boxId);

      if (result is DataSuccess<List<MyMedicineEntity>>) {
        final medicines = result.data ?? [];
        print('Successfully fetched ${medicines.length} medicines');

        for (final medicine in medicines) {
          print('Medicine: ${medicine.name} (ID: ${medicine.id})');
        }

        emit(
          state.copyWith(
            medicinesStatus: FormzSubmissionStatus.success,
            medicines: medicines,
          ),
        );
      } else {
        print('Failed to fetch medicines: ${result.error}');
        emit(
          state.copyWith(
            medicinesStatus: FormzSubmissionStatus.failure,
            medicinesErrorMessage: result.error ?? 'Failed to load medicines',
          ),
        );
      }
    } catch (e) {
      print('Exception while fetching medicines: $e');
      emit(
        state.copyWith(
          medicinesStatus: FormzSubmissionStatus.failure,
          medicinesErrorMessage: 'Unexpected error: $e',
        ),
      );
    }
  }

  void selectMedicine(String medicineId) {
    print('Selecting medicine: $medicineId');
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
