// Add pendingTreatments/pendingReminders to state (keep rest unchanged)
part of 'prescription_creation_cubit.dart';

enum CreationStep {
  prescription,
  treatment,
  reminder,
  completed,
}

class PrescriptionCreationState extends Equatable {
  const PrescriptionCreationState({
    this.currentStep = CreationStep.prescription,
    this.prescriptionForm = const CreatePrescriptionEntity(
      name: '',
      diseaseIds: [],
    ),
    this.prescriptionStatus = FormzSubmissionStatus.initial,
    this.prescriptionErrorMessage,
    this.createdPrescription,

    this.availableMedicines = const [],
    this.filteredMedicines = const [],
    this.medicineSearchQuery = '',
    this.medicinesStatus = FormzSubmissionStatus.initial,
    this.medicinesErrorMessage,

    this.treatmentForm = const CreateTreatmentEntity(
      prescriptionId: '',
      myMedicineId: '',
      dosage: '',
      frequency: '',
      durationDays: 0,
    ),
    this.treatmentStatus = FormzSubmissionStatus.initial,
    this.treatmentErrorMessage,
    this.createdTreatment,

    this.reminderForm = const CreateReminderEntity(
      treatmentId: '',
      reminderTimes: [],
      customMessage: '',
      startPreference: '',
    ),
    this.reminderTimes = const [],
    this.reminderCustomMessage = '',
    this.reminderStartPreference = 'START_NOW',
    this.reminderStatus = FormzSubmissionStatus.initial,
    this.reminderErrorMessage,
    this.createdReminders = const [],

    this.pendingTreatments = const [],
    this.pendingReminders = const [],

    this.successMessage,
  });

  // existing fields...
  final CreationStep currentStep;
  final CreatePrescriptionEntity prescriptionForm;
  final FormzSubmissionStatus prescriptionStatus;
  final String? prescriptionErrorMessage;
  final PrescriptionEntity? createdPrescription;

  final List<MyMedicineEntity> availableMedicines;
  final List<MyMedicineEntity> filteredMedicines;
  final String medicineSearchQuery;
  final FormzSubmissionStatus medicinesStatus;
  final String? medicinesErrorMessage;

  final CreateTreatmentEntity treatmentForm;
  final FormzSubmissionStatus treatmentStatus;
  final String? treatmentErrorMessage;
  final TreatmentEntity? createdTreatment;

  final CreateReminderEntity reminderForm;
  final List<ReminderTimeEntity> reminderTimes;
  final String reminderCustomMessage;
  final String reminderStartPreference;
  final FormzSubmissionStatus reminderStatus;
  final String? reminderErrorMessage;
  final List<ReminderEntity> createdReminders;

  // New: pending local items (not yet persisted to backend)
  // pendingTreatments: list of CreateTreatmentEntity (prescriptionId left empty until prescription created)
  final List<CreateTreatmentEntity> pendingTreatments;
  // pendingReminders: parallel list where pendingReminders[i] are ReminderTimeEntity list for pendingTreatments[i]
  final List<List<ReminderTimeEntity>> pendingReminders;

  // General
  final String? successMessage;

  PrescriptionCreationState copyWith({
    CreationStep? currentStep,
    CreatePrescriptionEntity? prescriptionForm,
    FormzSubmissionStatus? prescriptionStatus,
    String? prescriptionErrorMessage,
    PrescriptionEntity? createdPrescription,

    List<MyMedicineEntity>? availableMedicines,
    List<MyMedicineEntity>? filteredMedicines,
    String? medicineSearchQuery,
    FormzSubmissionStatus? medicinesStatus,
    String? medicinesErrorMessage,

    CreateTreatmentEntity? treatmentForm,
    FormzSubmissionStatus? treatmentStatus,
    String? treatmentErrorMessage,
    TreatmentEntity? createdTreatment,

    CreateReminderEntity? reminderForm,
    List<ReminderTimeEntity>? reminderTimes,
    String? reminderCustomMessage,
    String? reminderStartPreference,
    FormzSubmissionStatus? reminderStatus,
    String? reminderErrorMessage,
    List<ReminderEntity>? createdReminders,

    // New
    List<CreateTreatmentEntity>? pendingTreatments,
    List<List<ReminderTimeEntity>>? pendingReminders,

    String? successMessage,
  }) {
    return PrescriptionCreationState(
      currentStep: currentStep ?? this.currentStep,
      prescriptionForm: prescriptionForm ?? this.prescriptionForm,
      prescriptionStatus: prescriptionStatus ?? this.prescriptionStatus,
      prescriptionErrorMessage: prescriptionErrorMessage,
      createdPrescription: createdPrescription ?? this.createdPrescription,

      availableMedicines: availableMedicines ?? this.availableMedicines,
      filteredMedicines: filteredMedicines ?? this.filteredMedicines,
      medicineSearchQuery: medicineSearchQuery ?? this.medicineSearchQuery,
      medicinesStatus: medicinesStatus ?? this.medicinesStatus,
      medicinesErrorMessage: medicinesErrorMessage,

      treatmentForm: treatmentForm ?? this.treatmentForm,
      treatmentStatus: treatmentStatus ?? this.treatmentStatus,
      treatmentErrorMessage: treatmentErrorMessage,
      createdTreatment: createdTreatment ?? this.createdTreatment,

      reminderForm: reminderForm ?? this.reminderForm,
      reminderTimes: reminderTimes ?? this.reminderTimes,
      reminderCustomMessage: reminderCustomMessage ?? this.reminderCustomMessage,
      reminderStartPreference: reminderStartPreference ?? this.reminderStartPreference,
      reminderStatus: reminderStatus ?? this.reminderStatus,
      reminderErrorMessage: reminderErrorMessage,
      createdReminders: createdReminders ?? this.createdReminders,

      pendingTreatments: pendingTreatments ?? this.pendingTreatments,
      pendingReminders: pendingReminders ?? this.pendingReminders,

      successMessage: successMessage,
    );
  }

  // convenience getter: can create prescription when every pending treatment has at least one pending reminder
  bool get canCreatePrescriptionWithPending {
    if (pendingTreatments.isEmpty) return false;
    if (pendingReminders.length != pendingTreatments.length) return false;
    return pendingReminders.every((lst) => lst.isNotEmpty);
  }

  // include pending lists in props
  @override
  List<Object?> get props => [
    currentStep,
    prescriptionForm,
    prescriptionStatus,
    prescriptionErrorMessage,
    createdPrescription,
    availableMedicines,
    filteredMedicines,
    medicineSearchQuery,
    medicinesStatus,
    medicinesErrorMessage,
    treatmentForm,
    treatmentStatus,
    treatmentErrorMessage,
    createdTreatment,
    reminderForm,
    reminderTimes,
    reminderCustomMessage,
    reminderStartPreference,
    reminderStatus,
    reminderErrorMessage,
    createdReminders,
    pendingTreatments,
    pendingReminders,
    successMessage,
  ];
}