// lib/presentation/bloc/user_management/user_prescription_creation_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/reminder/simple_reminder_entity.dart';
import 'package:flutter_mobile/domain/repositories/user_prescription_repository.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_treatment_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/disease_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/treatment_entity.dart';
import 'package:flutter_mobile/domain/entities/services/PharmacyBoxEntity.dart';
import 'package:flutter_mobile/domain/entities/services/my_medicine_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_prescription_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/prescription_entity.dart';
import 'package:flutter_mobile/domain/repositories/disease_repository.dart';
import 'package:flutter_mobile/domain/repositories/medicine_repository.dart';
import 'package:flutter_mobile/domain/repositories/pharmacy_repository.dart';
import 'package:flutter_mobile/domain/repositories/user_reminder_repository.dart';
import 'package:flutter_mobile/domain/repositories/user_treatment_repository.dart';
import 'package:formz/formz.dart';

part 'user_prescription_creation_state.dart';

class UserPrescriptionCreationCubit extends Cubit<UserPrescriptionCreationState> {
  UserPrescriptionCreationCubit(
    this._userPrescriptionRepository,
    this._userTreatmentRepository,
    this._diseaseRepository,
    this._pharmacyRepository,
    this._medicineRepository,
     // this._userReminderRepository,
  ) : super(const UserPrescriptionCreationState());

  final UserPrescriptionRepository _userPrescriptionRepository;
  final UserTreatmentRepository _userTreatmentRepository;
  final DiseaseRepository _diseaseRepository;
  final PharmacyRepository _pharmacyRepository;
  final MedicineRepository _medicineRepository;
  //final UserReminderRepository _userReminderRepository; // ADD THIS
  // ============================================
  // Set User and Group Context
  // ============================================

  void setUserAndGroup(String userId, String groupId) {
    emit(state.copyWith(userId: userId, groupId: groupId));
  }

  // ============================================
  // Basic Field Updates (Same as home)
  // ============================================

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateSelectedDiseaseId(String? diseaseId) {
    emit(state.copyWith(selectedDiseaseId: diseaseId));
  }

  // --- Treatment form related update methods ---
  void updateTreatmentSelectedBox(String boxId) {
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

  // ============================================
  // Create Prescription for User (CHANGED: uses user repository)
  // ============================================

  Future<DataState<PrescriptionEntity>> createPrescription() async {
    if (state.userId.isEmpty || state.groupId.isEmpty) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'User ID and Group ID are required',
        ),
      );
      return DataError('missing_user_or_group');
    }

    final diseaseIds = <String>[];
    if (state.selectedDiseaseId != null &&
        state.selectedDiseaseId!.isNotEmpty) {
      diseaseIds.add(state.selectedDiseaseId!);
    }

    final createEntity = CreatePrescriptionEntity(
      name: state.name,
      diseaseIds: diseaseIds,
    );

    if (!createEntity.isValid) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Nom et maladie requis pour créer la prescription.',
        ),
      );
      return DataError('invalid_input');
    }

    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        errorMessage: null,
      ),
    );

    try {
      // CHANGED: Call user prescription repository
      final result = await _userPrescriptionRepository.createUserPrescription(
        groupId: state.groupId,
        userId: state.userId,
        createPrescriptionEntity: createEntity,
      );

      if (result is DataSuccess<PrescriptionEntity>) {
        emit(state.copyWith(status: FormzSubmissionStatus.success));
        return result;
      } else {
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

  // ============================================
  // Data Fetching Methods (SAME as home - no changes)
  // ============================================

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
    if (state.treatmentSelectedBox.isEmpty ||
        state.treatmentSelectedMedicineId.isEmpty) {
      return;
    }

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

  // ============================================
  // Create Treatment for User (CHANGED: uses user repository)
  // ============================================

  Future<DataState<TreatmentEntity>> createTreatmentForPrescription(
    CreateTreatmentEntity createTreatmentEntity,
  ) async {
    if (state.userId.isEmpty || state.groupId.isEmpty) {
      return DataError('User ID and Group ID are required');
    }

    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        errorMessage: null,
      ),
    );

    try {
      // CHANGED: Call user treatment repository
      final result = await _userTreatmentRepository.createUserTreatment(
        groupId: state.groupId,
        userId: state.userId,
        createTreatmentEntity: createTreatmentEntity,
      );

      if (result is DataSuccess<TreatmentEntity>) {
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
 /* // ADD THIS METHOD at the end of the cubit
  Future<DataState<List<SimpleReminderEntity>>> createSimpleReminders(
      SimpleCreateReminderEntity createReminderEntity,
      ) async {
    if (state.userId.isEmpty || state.groupId.isEmpty) {
      return DataError('User ID and Group ID are required');
    }

    try {
      emit(state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        errorMessage: null,
      ));

      // TODO: You need a createUserReminders method in UserReminderRepository
      // For now, this won't work because UserReminderRepository doesn't have this method
      // You need to add it to the repository first

      final result = await _userReminderRepository.createUserReminders(
        groupId: state.groupId,
        userId: state.userId,
        createReminderEntity: createReminderEntity,
      );

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
*/
}