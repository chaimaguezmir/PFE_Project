// lib/presentation/bloc/prescription/prescription_creation_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/prescription/prescription_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/treatment_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_prescription_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_treatment_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/reminder_time_entity.dart';
import 'package:flutter_mobile/domain/entities/services/my_medicine_entity.dart';
import 'package:flutter_mobile/domain/repositories/prescription_repository.dart';
import 'package:flutter_mobile/domain/repositories/treatment_repository.dart';
import 'package:flutter_mobile/domain/repositories/reminder_repository.dart';
import 'package:flutter_mobile/domain/repositories/medicine_repository.dart';
import 'package:formz/formz.dart';

part 'prescription_creation_state.dart';

class PrescriptionCreationCubit extends Cubit<PrescriptionCreationState> {
  PrescriptionCreationCubit({
    required this.prescriptionRepository,
    required this.treatmentRepository,
    required this.reminderRepository,
    required this.medicineRepository,
  }) : super(const PrescriptionCreationState());

  final PrescriptionRepository prescriptionRepository;
  final TreatmentRepository treatmentRepository;
  final ReminderRepository reminderRepository;
  final MedicineRepository medicineRepository;

  // ============================================
  // Prescription Creation Methods
  // ============================================

  /// Initialize prescription creation flow
  void initializePrescriptionCreation() {
    emit(
      state.copyWith(
        currentStep: CreationStep.prescription,
        prescriptionStatus: FormzSubmissionStatus.initial,
        treatmentStatus: FormzSubmissionStatus.initial,
        reminderStatus: FormzSubmissionStatus.initial,
        prescriptionErrorMessage: null,
        treatmentErrorMessage: null,
        reminderErrorMessage: null,
      ),
    );
  }

  /// Set prescription form data
  void setPrescriptionFormData({String? name, List<String>? diseaseIds}) {
    emit(
      state.copyWith(
        prescriptionForm: state.prescriptionForm.copyWith(
          name: name ?? state.prescriptionForm.name,
          diseaseIds: diseaseIds ?? state.prescriptionForm.diseaseIds,
        ),
      ),
    );
  }

  /// Validate prescription form
  bool validatePrescriptionForm() {
    final form = state.prescriptionForm;
    final isValid = form.isValid;

    if (!isValid) {
      emit(
        state.copyWith(
          prescriptionErrorMessage:
              'Veuillez remplir tous les champs obligatoires',
        ),
      );
    }

    return isValid;
  }

  /// Create prescription
  Future<void> createPrescription() async {
    if (!validatePrescriptionForm()) return;

    emit(
      state.copyWith(
        prescriptionStatus: FormzSubmissionStatus.inProgress,
        prescriptionErrorMessage: null,
      ),
    );

    try {
      final result = await prescriptionRepository.createPrescription(
        state.prescriptionForm,
      );

      if (result is DataSuccess<PrescriptionEntity>) {
        emit(
          state.copyWith(
            prescriptionStatus: FormzSubmissionStatus.success,
            createdPrescription: result.data,
            currentStep: CreationStep.treatment,
            successMessage: 'Prescription créée avec succès',
          ),
        );
      } else {
        emit(
          state.copyWith(
            prescriptionStatus: FormzSubmissionStatus.failure,
            prescriptionErrorMessage:
                result.error ?? 'Échec de la création de la prescription',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          prescriptionStatus: FormzSubmissionStatus.failure,
          prescriptionErrorMessage: 'Une erreur inattendue s\'est produite: $e',
        ),
      );
    }
  }

  // ============================================
  // Available Medicines Management
  // ============================================

  /// Fetch available medicines for treatment creation
  Future<void> fetchAvailableMedicines(String pharmacyBoxId) async {
    emit(
      state.copyWith(
        medicinesStatus: FormzSubmissionStatus.inProgress,
        medicinesErrorMessage: null,
      ),
    );

    try {
      final result = await medicineRepository.getMyMedicines(pharmacyBoxId);

      if (result is DataSuccess<List<MyMedicineEntity>>) {
        emit(
          state.copyWith(
            medicinesStatus: FormzSubmissionStatus.success,
            availableMedicines: result.data ?? [],
          ),
        );
      } else {
        emit(
          state.copyWith(
            medicinesStatus: FormzSubmissionStatus.failure,
            medicinesErrorMessage:
                result.error ?? 'Échec du chargement des médicaments',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          medicinesStatus: FormzSubmissionStatus.failure,
          medicinesErrorMessage: 'Une erreur inattendue s\'est produite: $e',
        ),
      );
    }
  }

  /// Filter medicines based on search query
  void searchMedicines(String query) {
    if (query.isEmpty) {
      emit(
        state.copyWith(
          filteredMedicines: state.availableMedicines,
          medicineSearchQuery: '',
        ),
      );
      return;
    }

    final filtered = state.availableMedicines
        .where(
          (medicine) =>
              medicine.name.toLowerCase().contains(query.toLowerCase()) ||
              medicine.manufacturerName.toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();

    emit(
      state.copyWith(filteredMedicines: filtered, medicineSearchQuery: query),
    );
  }

  /// Clear medicine search
  void clearMedicineSearch() {
    emit(
      state.copyWith(
        filteredMedicines: state.availableMedicines,
        medicineSearchQuery: '',
      ),
    );
  }

  // ============================================
  // Treatment Creation Methods
  // ============================================

  /// Set treatment form data
  void setTreatmentFormData({
    String? myMedicineId,
    String? dosage,
    String? frequency,
    int? durationDays,
  }) {
    final prescriptionId = state.createdPrescription?.id ?? '';

    emit(
      state.copyWith(
        treatmentForm: CreateTreatmentEntity(
          prescriptionId: prescriptionId,
          myMedicineId: myMedicineId ?? state.treatmentForm.myMedicineId,
          dosage: dosage ?? state.treatmentForm.dosage,
          frequency: frequency ?? state.treatmentForm.frequency,
          durationDays: durationDays ?? state.treatmentForm.durationDays,
        ),
      ),
    );
  }

  /// Validate treatment form
  bool validateTreatmentForm() {
    final form = state.treatmentForm;
    final isValid = form.isValid;

    if (!isValid) {
      emit(
        state.copyWith(
          treatmentErrorMessage:
              'Veuillez remplir tous les champs du traitement',
        ),
      );
    }

    return isValid;
  }

  /// Create treatment
  Future<void> createTreatment() async {
    if (!validateTreatmentForm()) return;

    emit(
      state.copyWith(
        treatmentStatus: FormzSubmissionStatus.inProgress,
        treatmentErrorMessage: null,
      ),
    );

    try {
      final result = await treatmentRepository.createTreatment(
        state.treatmentForm,
      );

      if (result is DataSuccess<TreatmentEntity>) {
        emit(
          state.copyWith(
            treatmentStatus: FormzSubmissionStatus.success,
            createdTreatment: result.data,
            currentStep: CreationStep.reminder,
            successMessage: 'Traitement créé avec succès',
          ),
        );
      } else {
        emit(
          state.copyWith(
            treatmentStatus: FormzSubmissionStatus.failure,
            treatmentErrorMessage:
                result.error ?? 'Échec de la création du traitement',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          treatmentStatus: FormzSubmissionStatus.failure,
          treatmentErrorMessage: 'Une erreur inattendue s\'est produite: $e',
        ),
      );
    }
  }

  // ============================================
  // Reminder Creation Methods
  // ============================================

  /// Add reminder time
  void addReminderTime(ReminderTimeEntity reminderTime) {
    final currentTimes = List<ReminderTimeEntity>.from(state.reminderTimes);

    // Check if this time slot already exists
    final existingIndex = currentTimes.indexWhere(
      (time) => time.timeSlot == reminderTime.timeSlot,
    );

    if (existingIndex != -1) {
      // Update existing time slot
      currentTimes[existingIndex] = reminderTime;
    } else {
      // Add new time slot
      currentTimes.add(reminderTime);
    }

    emit(state.copyWith(reminderTimes: currentTimes));
    _updateReminderForm();
  }

  /// Remove reminder time
  void removeReminderTime(String timeSlot) {
    final currentTimes = state.reminderTimes
        .where((time) => time.timeSlot != timeSlot)
        .toList();

    emit(state.copyWith(reminderTimes: currentTimes));
    _updateReminderForm();
  }

  /// Set reminder custom message
  void setReminderCustomMessage(String message) {
    emit(state.copyWith(reminderCustomMessage: message));
    _updateReminderForm();
  }

  /// Set reminder start preference
  void setReminderStartPreference(String startPreference) {
    emit(state.copyWith(reminderStartPreference: startPreference));
    _updateReminderForm();
  }

  /// Update reminder form based on current state
  void _updateReminderForm() {
    final treatmentId = state.createdTreatment?.id ?? '';

    final reminderForm = CreateReminderEntity(
      treatmentId: treatmentId,
      reminderTimes: state.reminderTimes,
      customMessage: state.reminderCustomMessage,
      startPreference: state.reminderStartPreference,
    );

    emit(state.copyWith(reminderForm: reminderForm));
  }

  /// Validate reminder form
  bool validateReminderForm() {
    final form = state.reminderForm;
    final isValid = form.isValid;

    if (!isValid) {
      String errorMessage = 'Veuillez configurer les rappels correctement';

      if (state.reminderTimes.isEmpty) {
        errorMessage = 'Ajoutez au moins un horaire de rappel';
      } else if (state.reminderCustomMessage.trim().isEmpty) {
        errorMessage = 'Saisissez un message personnalisé';
      } else if (state.reminderStartPreference.trim().isEmpty) {
        errorMessage = 'Sélectionnez quand commencer les rappels';
      }

      emit(state.copyWith(reminderErrorMessage: errorMessage));
    }

    return isValid;
  }

  /// Create reminders
  Future<void> createReminders() async {
    if (!validateReminderForm()) return;

    emit(
      state.copyWith(
        reminderStatus: FormzSubmissionStatus.inProgress,
        reminderErrorMessage: null,
      ),
    );

    try {
      final result = await reminderRepository.createReminders(
        state.reminderForm,
      );

      if (result is DataSuccess<List<ReminderEntity>>) {
        emit(
          state.copyWith(
            reminderStatus: FormzSubmissionStatus.success,
            createdReminders: result.data ?? [],
            currentStep: CreationStep.completed,
            successMessage: 'Rappels créés avec succès',
          ),
        );
      } else {
        emit(
          state.copyWith(
            reminderStatus: FormzSubmissionStatus.failure,
            reminderErrorMessage:
                result.error ?? 'Échec de la création des rappels',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          reminderStatus: FormzSubmissionStatus.failure,
          reminderErrorMessage: 'Une erreur inattendue s\'est produite: $e',
        ),
      );
    }
  }

  // ============================================
  // Step Navigation Methods
  // ============================================

  /// Go to next step
  void nextStep() {
    switch (state.currentStep) {
      case CreationStep.prescription:
        if (state.prescriptionStatus == FormzSubmissionStatus.success) {
          emit(state.copyWith(currentStep: CreationStep.treatment));
        }
        break;
      case CreationStep.treatment:
        if (state.treatmentStatus == FormzSubmissionStatus.success) {
          emit(state.copyWith(currentStep: CreationStep.reminder));
        }
        break;
      case CreationStep.reminder:
        if (state.reminderStatus == FormzSubmissionStatus.success) {
          emit(state.copyWith(currentStep: CreationStep.completed));
        }
        break;
      case CreationStep.completed:
        // Already at final step
        break;
    }
  }

  /// Go to previous step
  void previousStep() {
    switch (state.currentStep) {
      case CreationStep.prescription:
        // Can't go back from first step
        break;
      case CreationStep.treatment:
        emit(state.copyWith(currentStep: CreationStep.prescription));
        break;
      case CreationStep.reminder:
        emit(state.copyWith(currentStep: CreationStep.treatment));
        break;
      case CreationStep.completed:
        emit(state.copyWith(currentStep: CreationStep.reminder));
        break;
    }
  }

  /// Go to specific step
  void goToStep(CreationStep step) {
    emit(state.copyWith(currentStep: step));
  }

  // ============================================
  // Utility Methods
  // ============================================

  /// Clear all error messages
  void clearErrors() {
    emit(
      state.copyWith(
        prescriptionErrorMessage: null,
        treatmentErrorMessage: null,
        reminderErrorMessage: null,
        medicinesErrorMessage: null,
      ),
    );
  }

  /// Clear success message
  void clearSuccessMessage() {
    emit(state.copyWith(successMessage: null));
  }

  /// Reset entire creation flow
  void resetCreationFlow() {
    emit(const PrescriptionCreationState());
  }

  /// Skip reminder creation (optional step)
  void skipReminderCreation() {
    emit(
      state.copyWith(
        currentStep: CreationStep.completed,
        reminderStatus: FormzSubmissionStatus.success,
        successMessage: 'Prescription et traitement créés avec succès',
      ),
    );
  }

  /// Get progress percentage based on current step
  double getProgressPercentage() {
    switch (state.currentStep) {
      case CreationStep.prescription:
        return 0.25;
      case CreationStep.treatment:
        return 0.50;
      case CreationStep.reminder:
        return 0.75;
      case CreationStep.completed:
        return 1.0;
    }
  }

  /// Get step title for display
  String getStepTitle() {
    switch (state.currentStep) {
      case CreationStep.prescription:
        return 'Créer une prescription';
      case CreationStep.treatment:
        return 'Ajouter un traitement';
      case CreationStep.reminder:
        return 'Configurer les rappels';
      case CreationStep.completed:
        return 'Création terminée';
    }
  }

  /// Check if can proceed to next step
  bool canProceedToNextStep() {
    switch (state.currentStep) {
      case CreationStep.prescription:
        return state.prescriptionStatus == FormzSubmissionStatus.success;
      case CreationStep.treatment:
        return state.treatmentStatus == FormzSubmissionStatus.success;
      case CreationStep.reminder:
        return state.reminderStatus == FormzSubmissionStatus.success;
      case CreationStep.completed:
        return false; // Final step
    }
  }

  /// Check if currently processing any step
  bool get isProcessing {
    return state.prescriptionStatus == FormzSubmissionStatus.inProgress ||
        state.treatmentStatus == FormzSubmissionStatus.inProgress ||
        state.reminderStatus == FormzSubmissionStatus.inProgress ||
        state.medicinesStatus == FormzSubmissionStatus.inProgress;
  }

  /// Get summary of created entities
  Map<String, dynamic> getCreationSummary() {
    return {
      'prescription': state.createdPrescription?.name ?? 'Non créée',
      'treatment': state.createdTreatment?.medicationName ?? 'Non créé',
      'reminders': state.createdReminders.length,
      'step': state.currentStep.toString(),
      'isCompleted': state.currentStep == CreationStep.completed,
    };
  }

  /// Add a pending treatment with its reminder times (local only)
  void addPendingTreatment(
    CreateTreatmentEntity treatment,
    List<ReminderTimeEntity> reminders,
  ) {
    final pending = List<CreateTreatmentEntity>.from(state.pendingTreatments);
    final pendingRems = List<List<ReminderTimeEntity>>.from(
      state.pendingReminders,
    );
    pending.add(treatment);
    pendingRems.add(reminders);
    emit(
      state.copyWith(pendingTreatments: pending, pendingReminders: pendingRems),
    );
  }

  /// Remove pending treatment at index
  void removePendingTreatment(int index) {
    final pending = List<CreateTreatmentEntity>.from(state.pendingTreatments);
    final pendingRems = List<List<ReminderTimeEntity>>.from(
      state.pendingReminders,
    );
    if (index >= 0 && index < pending.length) {
      pending.removeAt(index);
      if (index < pendingRems.length) pendingRems.removeAt(index);
      emit(
        state.copyWith(
          pendingTreatments: pending,
          pendingReminders: pendingRems,
        ),
      );
    }
  }

  /// Update reminders for a pending treatment at index
  void updatePendingReminders(int index, List<ReminderTimeEntity> reminders) {
    final pendingRems = List<List<ReminderTimeEntity>>.from(
      state.pendingReminders,
    );
    while (pendingRems.length < state.pendingTreatments.length) {
      pendingRems.add([]);
    }
    if (index >= 0 && index < state.pendingTreatments.length) {
      pendingRems[index] = reminders;
      emit(state.copyWith(pendingReminders: pendingRems));
    }
  }

  /// Validate readiness to create prescription (must have at least one pending treatment and each pending treatment at least one reminder)
  bool validateReadyToCreatePrescription() {
    if (!state.canCreatePrescriptionWithPending) {
      emit(
        state.copyWith(
          prescriptionErrorMessage:
              'Ajoutez au moins un traitement avec au moins un rappel avant de valider la prescription',
        ),
      );
      return false;
    }
    return true;
  }

  /// Full flow: create prescription, then create each pending treatment and its reminders
  Future<void> createPrescriptionWithPending() async {
    if (!validateReadyToCreatePrescription()) return;

    // Create prescription first
    final createPresResult = await prescriptionRepository.createPrescription(
      state.prescriptionForm,
    );

    if (createPresResult is! DataSuccess<PrescriptionEntity>) {
      emit(
        state.copyWith(
          prescriptionStatus: FormzSubmissionStatus.failure,
          prescriptionErrorMessage:
              createPresResult.error ??
              'Échec de la création de la prescription',
        ),
      );
      return;
    }

    final createdPrescriptionEntity = createPresResult.data;
    emit(
      state.copyWith(
        prescriptionStatus: FormzSubmissionStatus.success,
        createdPrescription: createdPrescriptionEntity,
        successMessage: 'Prescription créée avec succès',
      ),
    );

    // Now create each pending treatment and its reminders sequentially
    final createdTreatments = <TreatmentEntity>[];
    final createdReminders = <ReminderEntity>[];

    for (int i = 0; i < state.pendingTreatments.length; i++) {
      final pendingTreatment = state.pendingTreatments[i];
      final remindersForThisTreatment = i < state.pendingReminders.length
          ? state.pendingReminders[i]
          : <ReminderTimeEntity>[];

      // Set prescriptionId now that prescription exists
      final treatmentToCreate = pendingTreatment.copyWith(
        prescriptionId: createdPrescriptionEntity!.id,
      );

      final treatmentResult = await treatmentRepository.createTreatment(
        treatmentToCreate,
      );
      if (treatmentResult is DataSuccess<TreatmentEntity>) {
        final createdT = treatmentResult.data;
        createdTreatments.add(createdT!);

        // Create reminders for this treatment
        final reminderRequest = CreateReminderEntity(
          treatmentId: createdT.id,
          reminderTimes: remindersForThisTreatment,
          customMessage: '', // adapt if you have custom message per treatment
          startPreference: state.reminderStartPreference,
        );

        final remindersResult = await reminderRepository.createReminders(
          reminderRequest,
        );
        if (remindersResult is DataSuccess<List<ReminderEntity>>) {
          createdReminders.addAll(remindersResult.data ?? []);
        } else {
          // handle partial failure: we log it and continue (or you can abort)
          emit(
            state.copyWith(
              reminderStatus: FormzSubmissionStatus.failure,
              reminderErrorMessage:
                  remindersResult.error ??
                  'Échec création rappels pour un traitement',
            ),
          );
          // Optionally continue or return; choose policy. Here we continue to try next treatment.
        }
      } else {
        emit(
          state.copyWith(
            treatmentStatus: FormzSubmissionStatus.failure,
            treatmentErrorMessage:
                treatmentResult.error ?? 'Échec création traitement',
          ),
        );
        // Optionally continue for other treatments or abort. We'll abort here.
        return;
      }
    }

    // All done: emit success and clear pending lists
    emit(
      state.copyWith(
        createdTreatment: createdTreatments.isNotEmpty
            ? createdTreatments.last
            : state.createdTreatment,
        createdReminders: createdReminders,
        pendingTreatments: const [],
        pendingReminders: const [],
        currentStep: CreationStep.completed,
        successMessage:
            'Prescription, traitements et rappels créés avec succès',
      ),
    );
  }
}
