// Stateless MedicalTreatmentForm that uses PrescriptionCreationCubit/state
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_treatment_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/treatment_entity.dart';
import 'package:flutter_mobile/domain/entities/reminder/reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/reminder/simple_create_reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/reminder/simple_reminder_time_entity.dart';
import 'package:flutter_mobile/domain/entities/services/PharmacyBoxEntity.dart';
import 'package:flutter_mobile/domain/entities/services/my_medicine_entity.dart';
import 'package:flutter_mobile/domain/repositories/reminder_repository.dart';
import 'package:flutter_mobile/domain/repositories/treatment_repository.dart';
import 'package:flutter_mobile/injection_container.dart';
import 'package:flutter_mobile/presentation/bloc/home/prescription_creation_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';

class MedicalTreatmentForm extends StatelessWidget {
  const MedicalTreatmentForm({
    super.key,
    this.onConfirmTreatment,
    this.prescriptionId,
    this.treatmentToEdit,
    this.isEditMode = false,
  });

  final VoidCallback? onConfirmTreatment;
  final String? prescriptionId;
  final TreatmentEntity? treatmentToEdit;
  final bool isEditMode;

  String _durationValueString(int days) => '$days jours';

  // Map backend time slot to frontend moment label
  String _mapTimeSlotToMoment(String timeSlot) {
    switch (timeSlot.toUpperCase()) {
      case 'MORNING':
        return 'Matin';
      case 'NOON':
        return 'Après Midi';
      case 'EVENING':
        return 'Soir';
      case 'NIGHT':
        return 'Nuit';
      default:
        return 'Matin'; // Default fallback
    }
  }

  // Map frontend moment label to backend time slot
  String _mapMomentToTimeSlot(String moment) {
    switch (moment) {
      case 'Matin':
        return 'MORNING';
      case 'Après Midi':
        return 'NOON';
      case 'Soir':
        return 'EVENING';
      case 'Nuit':
        return 'NIGHT';
      default:
        return 'MORNING';
    }
  }

  // Get default time for a moment (used when creating reminders)
  String _getDefaultTimeForMoment(String moment) {
    switch (moment) {
      case 'Matin':
        return '08:00';
      case 'Après Midi':
        return '12:00';
      case 'Soir':
        return '18:00';
      case 'Nuit':
        return '21:00';
      default:
        return '08:00';
    }
  }

  // Helper method to fetch reminders and pre-fill moments
  Future<void> _fetchAndPreFillReminders(
    PrescriptionCreationCubit cubit,
    String treatmentId,
  ) async {
    final reminderRepo = sl<ReminderRepository>();
    final result = await reminderRepo.getRemindersByTreatmentId(treatmentId);

    if (result is DataSuccess<List<ReminderEntity>>) {
      final reminders = result.data ?? [];
      if (reminders.isNotEmpty) {
        // Extract unique time slots (moments) from reminders
        final moments = reminders.map((r) => _mapTimeSlotToMoment(r.timeSlot)).toSet();
        cubit.updateTreatmentMoments(moments);

        // Note: Meal timing is not stored in reminders in the backend,
        // so we can't pre-fill it. It defaults to current state value.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrescriptionCreationCubit, PrescriptionCreationState>(
      builder: (context, state) {
        // Ensure pharmacy boxes are fetched once when needed
        SchedulerBinding.instance.addPostFrameCallback((_) {
          final cubit = context.read<PrescriptionCreationCubit>();
          if (state.pharmacyBoxes.isEmpty &&
              state.pharmacyBoxesStatus != FormzSubmissionStatus.inProgress) {
            cubit.fetchPharmacyBoxes();
          }

          // Pre-fill form if in edit mode
          if (isEditMode && treatmentToEdit != null && state.treatmentSelectedMedicineId.isEmpty) {
            // Set pharmacy box and fetch medicines
            final boxId = treatmentToEdit!.myMedicine.pharmacyBoxId;
            cubit.updateTreatmentSelectedBox(boxId);
            cubit.selectPharmacyBox(boxId);

            // Set medicine
            cubit.updateTreatmentSelectedMedicineId(treatmentToEdit!.myMedicine.id);

            // Set dosage, frequency, duration
            final dosageValue = int.tryParse(treatmentToEdit!.dosage) ?? 1;
            cubit.updateTreatmentDosage(dosageValue);
            cubit.updateTreatmentFrequency(treatmentToEdit!.frequency);
            cubit.updateTreatmentDurationDays(treatmentToEdit!.durationDays);

            // Fetch and pre-fill reminders
            _fetchAndPreFillReminders(cubit, treatmentToEdit!.id);
          }
        });

        final cubit = context.read<PrescriptionCreationCubit>();
        final canConfirm =
            state.treatmentSelectedBox.isNotEmpty &&
            state.treatmentSelectedMedicineId.isNotEmpty;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: isEditMode ? 'Modifier Traitement' : 'Ajouter Traitement',
          ),
          body: Column(
            children: [
              SizedBox(height: 20.h),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FormSectionLabel('Nom de la boîte'),
                      SizedBox(height: 8.h),
                      _PharmacyBoxDropdown(
                        selectedBox: state.treatmentSelectedBox,
                        pharmacyBoxes: state.pharmacyBoxes,
                        isLoading:
                            state.pharmacyBoxesStatus ==
                            FormzSubmissionStatus.inProgress,
                        onChanged: (boxId) {
                          if (boxId != null &&
                              boxId != state.treatmentSelectedBox) {
                            // update treatment selected box in cubit (resets treatment medicine)
                            cubit.updateTreatmentSelectedBox(boxId);
                            // fetch medicines for the selected box (existing cubit method)
                            cubit.selectPharmacyBox(boxId);
                          }
                        },
                      ),
                      SizedBox(height: 20.h),
                      const _FormSectionLabel('Sélectionner Médicament'),
                      SizedBox(height: 8.h),
                      _MedicineDropdown(
                        selectedMedicineId: state.treatmentSelectedMedicineId,
                        medicines: state.medicines,
                        isLoading:
                            state.medicinesStatus ==
                            FormzSubmissionStatus.inProgress,
                        isEnabled: state.treatmentSelectedBox.isNotEmpty,
                        onChanged: (medicineId) {
                          if (medicineId != null) {
                            cubit.updateTreatmentSelectedMedicineId(medicineId);
                            // keep global selectedMedicine in sync if desired
                            cubit.selectMedicine(medicineId);
                          }
                        },
                      ),
                      SizedBox(height: 20.h),
                      const _FormSectionLabel('Dosage'),
                      SizedBox(height: 8.h),
                      _DosageCircleSelector(
                        selectedDosage: state.treatmentSelectedDosage,
                        onSelected: (dosage) {
                          cubit.updateTreatmentDosage(dosage);
                        },
                      ),
                      SizedBox(height: 16.h),
                      const _FormSectionLabel('Fréquence'),
                      SizedBox(height: 8.h),
                      _CustomDropdown(
                        hintText: 'Sélectionner la fréquence',
                        value: state.treatmentSelectedFrequency,
                        items: const [
                          'Chaque jour',
                          'Tous les 2 jours',
                          'Tous les 3 jours',
                        ],
                        onChanged: (frequency) {
                          if (frequency != null) {
                            cubit.updateTreatmentFrequency(frequency);
                          }
                        },
                      ),
                      SizedBox(height: 20.h),
                      const _FormSectionLabel('Durée'),
                      SizedBox(height: 8.h),
                      _CustomDropdown(
                        hintText: 'Sélectionner la durée',
                        value: _durationValueString(
                          state.treatmentSelectedDurationDays,
                        ),
                        items: const ['7 jours', '30 jours', '60 jours'],
                        onChanged: (newValue) {
                          if (newValue != null) {
                            final days =
                                int.tryParse(newValue.split(' ').first) ?? 30;
                            cubit.updateTreatmentDurationDays(days);
                          }
                        },
                      ),
                      SizedBox(height: 20.h),
                      // Reminder fields (shown in both create and edit mode)
                      const _FormSectionLabel('Moment de la journée'),
                      SizedBox(height: 12.h),
                      _MomentsSelector(
                        selectedMoments: state.treatmentSelectedMoments,
                        onChanged: (moments) {
                          cubit.updateTreatmentMoments(moments);
                        },
                      ),
                      SizedBox(height: 16.h),
                      Center(
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 20.sp,
                          ),
                          label: Text(
                            'Ajouter une heure personnalisée',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      const _FormSectionLabel('Avant / Après / Avec repas'),
                      SizedBox(height: 8.h),
                      _MealTimingButtonSelector(
                        selectedMealTiming: state.treatmentMealTiming,
                        onSelected: (timing) {
                          if (timing != null) {
                            cubit.updateTreatmentMealTiming(timing);
                          }
                        },
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    ValidateButton(
                      text: isEditMode ? 'Modifier traitement' : 'Confirmer traitement',
                      onPressed: canConfirm
                          ? () async {
                              final scaffold = ScaffoldMessenger.of(context);

                              // EDIT MODE: Update existing treatment
                              if (isEditMode && treatmentToEdit != null) {
                                // 1. Update treatment
                                final repository = sl<TreatmentRepository>();
                                final result = await repository.updateTreatment(
                                  id: treatmentToEdit!.id,
                                  dosage: state.treatmentSelectedDosage.toString(),
                                  frequency: state.treatmentSelectedFrequency,
                                  durationDays: state.treatmentSelectedDurationDays,
                                );

                                if (result is DataSuccess) {
                                  // 2. Update reminders: delete old ones and create new ones
                                  final reminderRepo = sl<ReminderRepository>();

                                  // First, fetch existing reminders to preserve their times
                                  final existingRemindersResult = await reminderRepo.getRemindersByTreatmentId(treatmentToEdit!.id);

                                  // Create a map of existing reminder times by time slot
                                  final Map<String, String> existingTimesBySlot = {};
                                  List<ReminderEntity> remindersToDelete = [];

                                  if (existingRemindersResult is DataSuccess<List<ReminderEntity>>) {
                                    remindersToDelete = existingRemindersResult.data ?? [];
                                    print('Found ${remindersToDelete.length} existing reminders to delete');

                                    for (var reminder in remindersToDelete) {
                                      // Extract time from reminderTime DateTime
                                      final timeStr = '${reminder.reminderTime.hour.toString().padLeft(2, '0')}:${reminder.reminderTime.minute.toString().padLeft(2, '0')}';
                                      existingTimesBySlot[reminder.timeSlot] = timeStr;
                                      print('Preserved time for ${reminder.timeSlot}: $timeStr');
                                    }
                                  }

                                  // Delete all old reminders and wait for completion
                                  if (remindersToDelete.isNotEmpty) {
                                    print('Deleting ${remindersToDelete.length} old reminders...');
                                    for (var reminder in remindersToDelete) {
                                      print('Deleting reminder: ${reminder.id}');
                                      final deleteResult = await reminderRepo.deleteReminder(reminder.id);
                                      if (deleteResult is DataError) {
                                        print('Failed to delete reminder ${reminder.id}: ${deleteResult.error}');
                                      } else {
                                        print('Successfully deleted reminder: ${reminder.id}');
                                      }
                                    }
                                    print('Finished deleting all old reminders');
                                  }

                                  // Create new reminders if moments are selected
                                  if (state.treatmentSelectedMoments.isNotEmpty) {
                                    print('Creating ${state.treatmentSelectedMoments.length} new reminders...');

                                    // Create new reminders based on selected moments
                                    // Use existing times if available, otherwise use defaults
                                    final reminderTimes = state.treatmentSelectedMoments.map((moment) {
                                      final timeSlot = _mapMomentToTimeSlot(moment);
                                      // Use existing time if available, otherwise use default
                                      final time = existingTimesBySlot[timeSlot] ?? _getDefaultTimeForMoment(moment);
                                      print('Creating reminder for $moment ($timeSlot) at $time');
                                      return SimpleReminderTimeEntity(
                                        timeSlot: timeSlot,
                                        time: time,
                                      );
                                    }).toList();

                                    // Use START_NOW to preserve the treatment's original start date and duration
                                    // This ensures reminders are calculated from the treatment's createdAt date
                                    final createReminderEntity = SimpleCreateReminderEntity(
                                      treatmentId: treatmentToEdit!.id,
                                      reminderTimes: reminderTimes,
                                      startPreference: 'START_NOW',
                                    );

                                    final createResult = await reminderRepo.createReminders(createReminderEntity);
                                    if (createResult is DataSuccess) {
                                      print('Successfully created new reminders');
                                    } else if (createResult is DataError) {
                                      print('Failed to create reminders: ${createResult.error}');
                                    }
                                  } else {
                                    print('No moments selected, skipping reminder creation');
                                  }

                                  scaffold.showSnackBar(
                                    const SnackBar(
                                      content: Text('Traitement modifié avec succès!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  if (context.mounted) {
                                    context.pop(); // Go back to prescription detail
                                  }
                                } else {
                                  scaffold.showSnackBar(
                                    SnackBar(
                                      content: Text('Erreur: ${result.error ?? "Échec de la modification"}'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                                return;
                              }

                              // CREATE MODE: Check if we have a prescription ID (adding to existing prescription)
                              if (prescriptionId != null && prescriptionId!.isNotEmpty) {
                                // Create treatment for existing prescription
                                final createTreatmentEntity = CreateTreatmentEntity(
                                  prescriptionId: prescriptionId!,
                                  myMedicineId: state.treatmentSelectedMedicineId,
                                  dosage: state.treatmentSelectedDosage.toString(),
                                  frequency: state.treatmentSelectedFrequency,
                                  durationDays: state.treatmentSelectedDurationDays,
                                );

                                // Call the cubit to create treatment
                                final result = await cubit.createTreatmentForPrescription(
                                  createTreatmentEntity,
                                );

                                if (result is DataSuccess) {
                                  scaffold.showSnackBar(
                                    const SnackBar(
                                      content: Text('Traitement ajouté avec succès!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  if (context.mounted) {
                                    context.pop(); // Go back to prescription detail
                                  }
                                } else {
                                  scaffold.showSnackBar(
                                    SnackBar(
                                      content: Text('Erreur: ${result.error ?? "Échec de l'ajout"}'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } else {
                                // Original behavior: add to temp list for prescription creation flow
                                cubit.addTreatment();
                                if (onConfirmTreatment != null) {
                                  onConfirmTreatment!();
                                }
                                context.pop();
                              }
                            }
                          : null,
                      isEnabled: canConfirm,
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PharmacyBoxDropdown extends StatelessWidget {
  const _PharmacyBoxDropdown({
    required this.selectedBox,
    required this.pharmacyBoxes,
    required this.isLoading,
    this.onChanged,
  });

  final String selectedBox;
  final List<PharmacyBoxEntity> pharmacyBoxes;
  final bool isLoading;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: selectedBox.isEmpty ? null : selectedBox,
        decoration: InputDecoration(
          labelText: 'Sélectionner une boîte',
          floatingLabelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.w),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(
              color: selectedBox.isNotEmpty
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[300]!,
              width: selectedBox.isNotEmpty ? 2.w : 1.w,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2.w,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: pharmacyBoxes
            .map(
              (box) => DropdownMenuItem(
                value: box.id,
                child: Text(
                  box.groupName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey[600],
          size: 24.sp,
        ),
      ),
    );
  }
}

class _MedicineDropdown extends StatelessWidget {
  const _MedicineDropdown({
    required this.selectedMedicineId,
    required this.medicines,
    required this.isLoading,
    required this.isEnabled,
    this.onChanged,
  });

  final String selectedMedicineId;
  final List<MyMedicineEntity> medicines;
  final bool isLoading;
  final bool isEnabled;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print(
      '🔧 _MedicineDropdown build: isEnabled=$isEnabled isLoading=$isLoading medicines=${medicines.length} selected=$selectedMedicineId',
    );

    if (!isEnabled) {
      return Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Text(
            'Sélectionnez d\'abord une boîte',
            style: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
          ),
        ),
      );
    }

    if (isLoading) {
      return Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (medicines.isEmpty) {
      // ignore: avoid_print
      print('🔧 Showing empty medicines message');
      return Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Text(
            'Aucun médicament dans cette boîte',
            style: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
          ),
        ),
      );
    }

    // ignore: avoid_print
    print('🔧 Showing dropdown with ${medicines.length} medicines');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: selectedMedicineId.isEmpty ? null : selectedMedicineId,
        decoration: InputDecoration(
          labelText: 'Sélectionner un médicament',
          floatingLabelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.w),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(
              color: selectedMedicineId.isNotEmpty
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[300]!,
              width: selectedMedicineId.isNotEmpty ? 2.w : 1.w,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2.w,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: medicines
            .map(
              (medicine) => DropdownMenuItem(
                value: medicine.id,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      medicine.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey[600],
          size: 24.sp,
        ),
      ),
    );
  }
}

class _FormSectionLabel extends StatelessWidget {
  const _FormSectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}

class _CustomDropdown extends StatelessWidget {
  const _CustomDropdown({
    required this.hintText,
    this.value,
    required this.items,
    this.onChanged,
  });
  final String hintText;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: hintText,
          floatingLabelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.w),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(
              color: value != null
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[300]!,
              width: value != null ? 2.w : 1.w,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2.w,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey[600],
          size: 24.sp,
        ),
      ),
    );
  }
}

class _DosageCircleSelector extends StatelessWidget {
  const _DosageCircleSelector({required this.selectedDosage, this.onSelected});
  final int selectedDosage;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(20, (index) {
            final dosage = index + 1;
            final isSelected = dosage == selectedDosage;
            return Container(
              margin: EdgeInsets.only(right: 12.w),
              child: GestureDetector(
                onTap: () => onSelected?.call(dosage),
                child: Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.grey[200],
                  ),
                  child: Center(
                    child: Text(
                      dosage.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _MomentsSelector extends StatelessWidget {
  const _MomentsSelector({required this.selectedMoments, this.onChanged});
  final Set<String> selectedMoments;
  final ValueChanged<Set<String>>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      children: ['Matin', 'Après Midi', 'Soir', 'Nuit'].map((label) {
        final selected = selectedMoments.contains(label);
        return FilterChip(
          label: Text(label),
          selected: selected,
          onSelected: (isOn) {
            if (onChanged == null) return;
            final newMoments = Set<String>.from(selectedMoments);
            if (isOn) {
              newMoments.add(label);
            } else {
              newMoments.remove(label);
            }
            onChanged!(newMoments);
          },
          selectedColor: Theme.of(context).colorScheme.secondary,
        );
      }).toList(),
    );
  }
}

class _MealTimingButtonSelector extends StatelessWidget {
  const _MealTimingButtonSelector({
    required this.selectedMealTiming,
    this.onSelected,
  });
  final String selectedMealTiming;
  final ValueChanged<String?>? onSelected;

  @override
  Widget build(BuildContext context) {
    final mealOptions = ['Avant repas', 'Après Repas', 'Avec Repas'];
    return Row(
      children: mealOptions.map((option) {
        final isSelected = option == selectedMealTiming;
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.white,
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.grey[300]!,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              onPressed: () => onSelected?.call(option),
              child: Text(
                option,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.secondary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class ValidateButton extends StatelessWidget {
  const ValidateButton({
    super.key,
    this.onPressed,
    this.text = 'Validé',
    this.isEnabled = true,
  });
  final VoidCallback? onPressed;
  final String text;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: Offset(0, 4.h),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? Theme.of(context).colorScheme.secondary
              : Colors.grey[400],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
          elevation: 0,
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.colorScheme.onSecondary,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 55.h,
      leading: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            backgroundColor: theme.colorScheme.onSecondary,
            padding: EdgeInsets.zero,
            elevation: 4,
          ),
          child: Icon(
            Icons.arrow_back,
            color: theme.colorScheme.onPrimary,
            size: 18.sp,
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(55.h);
}
