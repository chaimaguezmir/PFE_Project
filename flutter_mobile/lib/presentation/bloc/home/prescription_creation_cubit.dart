// lib/presentation/bloc/prescription/prescription_creation_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_treatment_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/disease_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/treatment_entity.dart';
import 'package:flutter_mobile/domain/entities/reminder/simple_create_reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/reminder/simple_reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/services/PharmacyBoxEntity.dart';
import 'package:flutter_mobile/domain/entities/services/my_medicine_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_prescription_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/prescription_entity.dart';
import 'package:flutter_mobile/domain/repositories/disease_repository.dart';
import 'package:flutter_mobile/domain/repositories/medicine_repository.dart';
import 'package:flutter_mobile/domain/repositories/pharmacy_repository.dart';
import 'package:flutter_mobile/domain/repositories/prescription_repository.dart';
import 'package:flutter_mobile/domain/repositories/reminder_repository.dart';
import 'package:flutter_mobile/domain/repositories/treatment_repository.dart';
import 'package:formz/formz.dart';

part 'prescription_creation_state.dart';

class PrescriptionCreationCubit extends Cubit<PrescriptionCreationState> {
  PrescriptionCreationCubit(
    this._prescriptionRepository,
    this._diseaseRepository,
    this._pharmacyRepository,
    this._medicineRepository,
    this._treatmentRepository,
    this._reminderRepository,
  ) : super(const PrescriptionCreationState());

  final PrescriptionRepository _prescriptionRepository;
  final DiseaseRepository _diseaseRepository;
  final PharmacyRepository _pharmacyRepository;
  final MedicineRepository _medicineRepository;
  final TreatmentRepository _treatmentRepository;
  final ReminderRepository _reminderRepository;
  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateSelectedDiseaseId(String? diseaseId) {
    emit(state.copyWith(selectedDiseaseId: diseaseId));
  }

  // --- Treatment form related update methods ---
  void updateTreatmentSelectedBox(String boxId) {
    // Update the treatment selected box and reset treatment medicine selection
    emit(
      state.copyWith(
        treatmentSelectedBox: boxId,
        treatmentSelectedMedicineId: '',
      ),
    );
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

  /// Create prescription on backend using state.name and selected disease(s).
  /// Returns the DataState returned by repository so UI can handle it.
  Future<DataState<PrescriptionEntity>> createPrescription() async {
    // Build CreatePrescriptionEntity from state
    // If you support multiple diseases in the future, adapt this to use the list.
    final diseaseIds = <String>[];
    if (state.selectedDiseaseId != null &&
        state.selectedDiseaseId!.isNotEmpty) {
      diseaseIds.add(state.selectedDiseaseId!);
    }

    final createEntity = CreatePrescriptionEntity(
      name: state.name,
      diseaseIds: diseaseIds,
    );

    // Basic validation before calling repository
    if (!createEntity.isValid) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Nom et maladie requis pour créer la prescription.',
        ),
      );
      // Return a DataFailed-like object: easiest is to return a DataFailed with the message
      return DataError('invalid_input');
    }

    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        errorMessage: null,
      ),
    );

    try {
      final result = await _prescriptionRepository.createPrescription(
        createEntity,
      );

      if (result is DataSuccess<PrescriptionEntity>) {
        // On success, update state.status (and optionally save created prescription in state)
        emit(state.copyWith(status: FormzSubmissionStatus.success));
        return result;
      } else {
        // DataFailed or other error
        final error = (result is DataError)
            ? result.error
            : 'Failed to create prescription';
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: error,
          ),
        );
        return DataError(error!);
      }
    } catch (e) {
      final err = 'Unexpected error: $e';
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: err,
        ),
      );
      return DataError(err);
    }
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
            pharmacyBoxesErrorMessage:
                result.error ?? 'Failed to load pharmacy boxes',
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
    emit(
      state.copyWith(
        selectedPharmacyBoxId: boxId,
        medicines: [],
        selectedMedicineId: null,
      ),
    );
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

  /// Builds a treatment Map from current treatment fields and appends it to
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
    emit(
      state.copyWith(
        treatments: updatedList,
        treatmentSelectedBox: '',
        treatmentSelectedMedicineId: '',
        treatmentSelectedDosage: 1,
        treatmentSelectedFrequency: 'Chaque jour',
        treatmentSelectedDurationDays: 30,
        treatmentSelectedMoments: const {'Matin', 'Après Midi'},
        treatmentMealTiming: 'Avant repas',
        treatmentSearchQuery: '',
      ),
    );
  }

  Future<DataState<TreatmentEntity>> createTreatmentForPrescription(
    CreateTreatmentEntity createTreatmentEntity,
  ) async {
    // emit an in-progress status (optional)
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        errorMessage: null,
      ),
    );

    try {
      final result = await _treatmentRepository.createTreatment(
        createTreatmentEntity,
      );

      if (result is DataSuccess<TreatmentEntity>) {
        // success: update status and return success
        emit(state.copyWith(status: FormzSubmissionStatus.success));
        return result;
      } else {
        final err = (result is DataError)
            ? result.error
            : 'Failed to create treatment';
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: err,
          ),
        );
        return DataError(err!);
      }
    } catch (e) {
      final err = 'Unexpected error: $e';
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: err,
        ),
      );
      return DataError(err);
    }
  }

  /// Create multiple treatments for a prescription using the provided list of saved treatment maps
  /// (for example, your state.treatments list). This helper builds CreateTreatmentEntity objects
  /// for each map and calls createTreatmentForPrescription sequentially.
  /// Returns a list of DataState results (one per treatment).
  ///
  /// - `treatments`: List<Map<String, dynamic>> (each map should contain medicineId/myMedicineId, dosage, frequency, durationDays, etc.)
  /// - `prescriptionId`: the prescription id (string) to include in each CreateTreatmentEntity
  /// - `stopOnFailure`: if true, stop creating further treatments on first failure; default false
  ///
  /// Example usage (from UI after creating prescription):
  ///   final results = await createTreatmentsForPrescription(createdPrescriptionId, cubit.state.treatments);
  Future<List<DataState<TreatmentEntity>>> createTreatmentsForPrescription(
    String prescriptionId,
    List<Map<String, dynamic>> treatments, {
    bool stopOnFailure = false,
  }) async {
    final results = <DataState<TreatmentEntity>>[];

    for (final t in treatments) {
      final String myMedicineId =
          (t['medicineId'] as String?) ?? (t['myMedicineId'] as String?) ?? '';
      final String dosage = (t['dosage'] != null)
          ? t['dosage'].toString()
          : '1';
      final String frequency = (t['frequency'] as String?) ?? 'daily';
      final int durationDays =
          (t['durationDays'] as int?) ??
          (t['duration'] as int?) ??
          int.tryParse('${t['durationDays'] ?? t['duration'] ?? 30}') ??
          30;

      final createTreatment = CreateTreatmentEntity(
        prescriptionId: prescriptionId,
        myMedicineId: myMedicineId,
        dosage: dosage,
        frequency: frequency,
        durationDays: durationDays,
      );

      final treatmentResult = await createTreatmentForPrescription(
        createTreatment,
      );
      results.add(treatmentResult);

      if (treatmentResult is DataError && stopOnFailure) {
        break;
      }
    }

    return results;
  }

  Future<DataState<List<SimpleReminderEntity>>> createSimpleReminders(
      SimpleCreateReminderEntity createReminderEntity,
      ) async {
    try {
      emit(state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        errorMessage: null,
      ));

      final result = await _reminderRepository.createReminders(createReminderEntity);

      if (result is DataSuccess<List<SimpleReminderEntity>>) {
        emit(state.copyWith(status: FormzSubmissionStatus.success));
        return result;
      } else {
        final err = (result is DataError)
            ? result.error
            : 'Failed to create reminders';
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: err,
        ));
        return DataError(err!);
      }
    } catch (e) {
      final err = 'Unexpected error: $e';
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: err,
      ));
      return DataError(err);
    }
  }
}
