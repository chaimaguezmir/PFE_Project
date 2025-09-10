// Completely Stateless MedicalPrescriptionForm (shows treatments saved in cubit)
// Updated: enable "Valider la prescription" only when name, disease and at least one treatment exist.
// On press it prints the next-step info to console (no navigation / repo changes).
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_treatment_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/disease_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/prescription_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/reminder_time_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/treatment_entity.dart';
import 'package:flutter_mobile/domain/entities/reminder/simple_create_reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/reminder/simple_reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/reminder/simple_reminder_time_entity.dart';
import 'package:flutter_mobile/presentation/bloc/home/prescription_creation_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MedicationData {
  MedicationData({
    required this.name,
    required this.duration,
    required this.instructions,
    required this.percentage,
  });
  final String name;
  final String duration;
  final String instructions;
  final int percentage;
}

class MedicalPrescriptionForm extends StatelessWidget {
  const MedicalPrescriptionForm({
    super.key,
    this.onTreatmentNameChanged,
    this.onDiseaseTypeChanged,
    this.onAddTreatmentPressed,
    this.onValidatePressed,
    this.medications = const [],
    this.pendingTreatments = const [],
    this.treatmentName = '',
    this.selectedDiseaseType,
    this.canValidate = false,
  });

  final ValueChanged<String>? onTreatmentNameChanged;
  final ValueChanged<String>? onDiseaseTypeChanged;
  final VoidCallback? onAddTreatmentPressed;
  final VoidCallback? onValidatePressed;
  final List<MedicationData> medications;
  final List<String> pendingTreatments;
  final String treatmentName;
  final String? selectedDiseaseType;
  final bool canValidate;

  @override
  Widget build(BuildContext context) {
    // We'll display either the provided medications param, or the saved treatments from cubit,
    // otherwise the MedicationsList will show the "Aucune prescription ajoutée" state.
    return BlocBuilder<PrescriptionCreationCubit, PrescriptionCreationState>(
      builder: (context, state) {
        // Convert cubit.saved treatments (List<Map<String, dynamic>>) into MedicationData
        final medicationsFromState = (state.treatments).map<MedicationData>((
          t,
        ) {
          final name =
              (t['medicineName'] as String?) ??
              (t['medicineId'] as String?) ??
              '';
          final duration = t['durationDays'] != null
              ? '${t['durationDays']} jours'
              : (t['duration'] as String?) ?? '';
          final dosage = t['dosage']?.toString() ?? '';
          final frequency = (t['frequency'] as String?) ?? '';
          final mealTiming = (t['mealTiming'] as String?) ?? '';
          final momentsList =
              (t['moments'] as List<dynamic>?)?.cast<String>() ?? <String>[];
          final instructionsParts = <String>[];
          if (dosage.isNotEmpty) instructionsParts.add('$dosage prise(s)');
          if (frequency.isNotEmpty) instructionsParts.add(frequency);
          if (momentsList.isNotEmpty)
            instructionsParts.add(momentsList.join(', '));
          if (mealTiming.isNotEmpty) instructionsParts.add(mealTiming);
          final instructions = instructionsParts.isNotEmpty
              ? instructionsParts.join(' · ')
              : '';

          final percentage = t['percentage'] is int
              ? t['percentage'] as int
              : 0;

          return MedicationData(
            name: name,
            duration: duration.isNotEmpty ? duration : '30 jours',
            instructions: instructions.isNotEmpty ? instructions : '',
            percentage: percentage,
          );
        }).toList();

        // Decide which list to display: prefer the passed `medications` prop,
        // otherwise use treatments saved in cubit. If both are empty, MedicationsList
        // will render the empty-state UI.
        final displayMedications = medications.isNotEmpty
            ? medications
            : medicationsFromState;

        // Compute whether the "Valider la prescription" button should be enabled:
        final hasName = state.name.trim().isNotEmpty;
        final hasDisease =
            state.selectedDiseaseId != null &&
            state.selectedDiseaseId!.isNotEmpty;
        final hasAtLeastOneTreatment = state.treatments.isNotEmpty;
        final enableValidateButton =
            hasName && hasDisease && hasAtLeastOneTreatment;
        final cubit = context.read<PrescriptionCreationCubit>();
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: 'Ajouter Une prescription'),
          body: Column(
            children: [
              SizedBox(height: 20.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TreatmentNameInput(
                            value: state.name,
                            onChanged: (name) => context
                                .read<PrescriptionCreationCubit>()
                                .updateName(name),
                          ),
                          SizedBox(height: 20.h),
                          CustomDropdown(
                            hintText: 'Type de Maladie',
                            items: state.diseases
                                .map((disease) => disease.name)
                                .toList(),
                            value: state.diseases
                                .cast<DiseaseEntity?>()
                                .firstWhere(
                                  (d) => d?.id == state.selectedDiseaseId,
                                  orElse: () => null,
                                )
                                ?.name,
                            onChanged: (diseaseName) {
                              if (diseaseName == null) return;
                              final disease = state.diseases.firstWhere(
                                (d) => d.name == diseaseName,
                              );
                              context
                                  .read<PrescriptionCreationCubit>()
                                  .updateSelectedDiseaseId(disease.id);
                            },
                          ),
                          SizedBox(height: 20.h),
                          AddPrescriptionButton(
                            onPressed: onAddTreatmentPressed,
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                    Expanded(
                      child: MedicationsList(medications: displayMedications),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          ValidateButton(
                            onPressed: enableValidateButton
                                ? () async {
                                    final scaffold = ScaffoldMessenger.of(
                                      context,
                                    );
                                    final cubit = context
                                        .read<PrescriptionCreationCubit>();

                                    try {
                                      // 1) Create prescription
                                      scaffold.showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Création de la prescription...',
                                          ),
                                        ),
                                      );

                                      final createPrescriptionResult =
                                          await cubit.createPrescription();

                                      if (createPrescriptionResult
                                          is! DataSuccess<PrescriptionEntity>) {
                                        final err =
                                            (createPrescriptionResult
                                                is DataError)
                                            ? createPrescriptionResult.error
                                            : 'Erreur création prescription';
                                        scaffold.showSnackBar(
                                          SnackBar(
                                            content: Text('Erreur: $err'),
                                          ),
                                        );
                                        return;
                                      }

                                      final String createdPrescriptionId =
                                          createPrescriptionResult.data!.id;
                                      print(
                                        'Prescription created id: $createdPrescriptionId',
                                      );

                                      // 2) Create treatments
                                      final savedTreatments =
                                          List<Map<String, dynamic>>.from(
                                            cubit.state.treatments,
                                          );

                                      if (savedTreatments.isNotEmpty) {
                                        scaffold.showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Création des traitements...',
                                            ),
                                          ),
                                        );

                                        final treatmentResults = await cubit
                                            .createTreatmentsForPrescription(
                                              createdPrescriptionId,
                                              savedTreatments,
                                            );

                                        // 3) Create reminders for each successful treatment
                                        final List<String> failedReminders = [];
                                        int successfulReminders = 0;

                                        for (
                                          int i = 0;
                                          i < treatmentResults.length;
                                          i++
                                        ) {
                                          final treatmentResult =
                                              treatmentResults[i];
                                          final savedTreatment =
                                              savedTreatments[i];

                                          if (treatmentResult
                                              is DataSuccess<TreatmentEntity>) {
                                            final createdTreatment =
                                                treatmentResult.data!;

                                            // ENHANCED DEBUGGING: Show what data we're working with
                                            print(
                                              '🔍 DEBUGGING Treatment Data:',
                                            );
                                            print(
                                              '  Treatment ID: ${createdTreatment.id}',
                                            );
                                            print(
                                              '  Medicine Name: ${createdTreatment.myMedicine.name}',
                                            );

                                            print(
                                              '🔍 DEBUGGING Saved Treatment Data:',
                                            );
                                            print(
                                              '  Full savedTreatment: $savedTreatment',
                                            );
                                            savedTreatment.forEach((
                                              key,
                                              value,
                                            ) {
                                              print(
                                                '    $key: $value (type: ${value.runtimeType})',
                                              );
                                            });

                                            // Extract reminder data with debugging
                                            final List<dynamic> moments =
                                                (savedTreatment['moments']
                                                    as List<dynamic>?) ??
                                                [];
                                            final String mealTiming =
                                                (savedTreatment['mealTiming']
                                                    as String?) ??
                                                'après repas';

                                            print(
                                              '🔍 DEBUGGING Extracted Data:',
                                            );
                                            print(
                                              '  moments: $moments (type: ${moments.runtimeType}, length: ${moments.length})',
                                            );
                                            print(
                                              '  mealTiming: "$mealTiming"',
                                            );

                                            if (moments.isNotEmpty) {
                                              print(
                                                '✅ Moments found, creating simple reminders for treatment: ${createdTreatment.id}',
                                              );

                                              // Convert moments to simple reminder times with debugging
                                              final List<
                                                SimpleReminderTimeEntity
                                              >
                                              reminderTimes = [];

                                              print(
                                                '🔍 Converting moments to reminder times:',
                                              );
                                              for (
                                                int idx = 0;
                                                idx < moments.length;
                                                idx++
                                              ) {
                                                final moment = moments[idx];
                                                final momentStr = moment
                                                    .toString()
                                                    .toLowerCase()
                                                    .trim();
                                                print(
                                                  '  [$idx] Original moment: "$moment" -> processed: "$momentStr"',
                                                );

                                                String timeSlot;
                                                String defaultTime;

                                                if (momentStr.contains(
                                                  'matin',
                                                )) {
                                                  timeSlot = 'MORNING';
                                                  defaultTime = '08:00';
                                                } else if (momentStr.contains(
                                                      'aprÃ¨',
                                                    ) ||
                                                    momentStr.contains(
                                                      'midi',
                                                    )) {
                                                  timeSlot =
                                                      'NOON'; // Changed from 'AFTERNOON' to 'NOON'
                                                  defaultTime = '12:00';
                                                } else if (momentStr.contains(
                                                  'soir',
                                                )) {
                                                  timeSlot = 'EVENING';
                                                  defaultTime = '18:00';
                                                } else if (momentStr.contains(
                                                  'nuit',
                                                )) {
                                                  timeSlot = 'NIGHT';
                                                  defaultTime = '21:00';
                                                } else {
                                                  print(
                                                    '⚠️ Unknown moment "$momentStr", using MORNING as default',
                                                  );
                                                  timeSlot = 'MORNING';
                                                  defaultTime = '08:00';
                                                }

                                                print(
                                                  '    Mapped to -> timeSlot: "$timeSlot", time: "$defaultTime"',
                                                );

                                                reminderTimes.add(
                                                  SimpleReminderTimeEntity(
                                                    timeSlot: timeSlot,
                                                    time: defaultTime,
                                                  ),
                                                );
                                              }

                                              print(
                                                '🔍 Total reminder times before deduplication: ${reminderTimes.length}',
                                              );

                                              // Remove duplicates with debugging
                                              final uniqueTimes =
                                                  <
                                                    String,
                                                    SimpleReminderTimeEntity
                                                  >{};
                                              for (final rt in reminderTimes) {
                                                if (uniqueTimes.containsKey(
                                                  rt.timeSlot,
                                                )) {
                                                  print(
                                                    '  Duplicate timeSlot found: ${rt.timeSlot}, keeping first occurrence',
                                                  );
                                                } else {
                                                  uniqueTimes[rt.timeSlot] = rt;
                                                }
                                              }

                                              print(
                                                '🔍 Unique reminder times: ${uniqueTimes.length}',
                                              );
                                              uniqueTimes.forEach((key, value) {
                                                print('  $key: ${value.time}');
                                              });

                                              if (uniqueTimes.isNotEmpty) {
                                                final customMessage =
                                                    'Prendre ${createdTreatment.myMedicine.name} - $mealTiming';
                                                print(
                                                  '🔍 Creating SimpleCreateReminderEntity with:',
                                                );
                                                print(
                                                  '  treatmentId: "${createdTreatment.id}"',
                                                );
                                                print(
                                                  '  reminderTimes count: ${uniqueTimes.values.length}',
                                                );
                                                print(
                                                  '  customMessage: "$customMessage"',
                                                );
                                                print(
                                                  '  startPreference: "START_NEXT_CYCLE"',
                                                );

                                                final simpleReminder =
                                                    SimpleCreateReminderEntity(
                                                      treatmentId:
                                                          createdTreatment.id,
                                                      reminderTimes: uniqueTimes
                                                          .values
                                                          .toList(),
                                                      customMessage:
                                                          customMessage,
                                                      startPreference:
                                                          'START_NEXT_CYCLE',
                                                    );

                                                // This will now show detailed validation info
                                                if (simpleReminder.isValid) {
                                                  print(
                                                    '✅ SimpleCreateReminderEntity validation passed, calling API...',
                                                  );
                                                  final remindersResult =
                                                      await cubit
                                                          .createSimpleReminders(
                                                            simpleReminder,
                                                          );

                                                  if (remindersResult
                                                      is DataSuccess<
                                                        List<
                                                          SimpleReminderEntity
                                                        >
                                                      >) {
                                                    successfulReminders +=
                                                        remindersResult
                                                            .data!
                                                            .length;
                                                    print(
                                                      '✅ Successfully created ${remindersResult.data!.length} simple reminders',
                                                    );
                                                  } else {
                                                    failedReminders.add(
                                                      createdTreatment
                                                          .myMedicine
                                                          .name,
                                                    );
                                                    print(
                                                      '❌ Failed to create simple reminders: ${remindersResult.error}',
                                                    );
                                                  }
                                                } else {
                                                  failedReminders.add(
                                                    createdTreatment
                                                        .myMedicine
                                                        .name,
                                                  );
                                                  print(
                                                    '❌ Simple reminder validation failed - check logs above for details',
                                                  );
                                                }
                                              } else {
                                                print(
                                                  '❌ No unique reminder times created',
                                                );
                                                failedReminders.add(
                                                  createdTreatment
                                                      .myMedicine
                                                      .name,
                                                );
                                              }
                                            } else {
                                              print(
                                                '⚠️ No moments found in savedTreatment data',
                                              );
                                              print(
                                                '   Available keys in savedTreatment: ${savedTreatment.keys.toList()}',
                                              );
                                            }
                                          } else {
                                            print(
                                              '❌ Treatment creation failed: ${(treatmentResult as DataError).error}',
                                            );
                                          }
                                        }

                                        // Show final result
                                        if (failedReminders.isEmpty &&
                                            successfulReminders > 0) {
                                          scaffold.showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Prescription créée avec $successfulReminders rappels!',
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        } else if (failedReminders.isNotEmpty) {
                                          scaffold.showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Prescription créée. Échec rappels: ${failedReminders.join(", ")}',
                                              ),
                                              backgroundColor: Colors.orange,
                                            ),
                                          );
                                        } else {
                                          scaffold.showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Prescription et traitements créés!',
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        scaffold.showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Prescription créée sans traitements',
                                            ),
                                          ),
                                        );
                                      }

                                      // Navigate back
                                      if (onValidatePressed != null) {
                                        onValidatePressed!();
                                      }
                                      context.pop();
                                    } catch (e) {
                                      scaffold.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Erreur inattendue: $e',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                : null,
                            text: 'Valider la prescription',
                            isEnabled: enableValidateButton,
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
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

class TreatmentNameInput extends StatelessWidget {
  const TreatmentNameInput({super.key, required this.value, this.onChanged});
  final String value;
  final ValueChanged<String>? onChanged;

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
      child: TextFormField(
        initialValue: value,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: 'Nom Traitement',
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
              color: value.isNotEmpty
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[300]!,
              width: value.isNotEmpty ? 2.w : 1.w,
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
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.hintText,
    required this.items,
    this.onChanged,
    this.value,
  });
  final String hintText;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final String? value;

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
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.w),
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

class AddPrescriptionButton extends StatelessWidget {
  const AddPrescriptionButton({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Ajouter traitement',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          GestureDetector(
            onTap: () => context.pushNamed(AppRouteName.treatmentForm),
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.white, size: 20.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class MedicationsList extends StatelessWidget {
  const MedicationsList({super.key, required this.medications});
  final List<MedicationData> medications;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: medications.isEmpty
          ? SingleChildScrollView(
              child: SizedBox(
                height: 200.h,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.medication_outlined,
                        size: 64.sp,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Aucune prescription ajoutée',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Ajoutez votre première prescription',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: medications.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) =>
                  MedicationCard(medication: medications[index]),
            ),
    );
  }
}

class MedicationCard extends StatelessWidget {
  const MedicationCard({super.key, required this.medication});
  final MedicationData medication;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication.name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  medication.duration,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  medication.instructions,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          PercentageBadge(percentage: medication.percentage),
        ],
      ),
    );
  }
}

class PercentageBadge extends StatelessWidget {
  const PercentageBadge({super.key, required this.percentage});
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.w,
      height: 60.w,
      child: Stack(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[200]!, width: 3.w),
            ),
          ),
          SizedBox(
            width: 60.w,
            height: 60.w,
            child: CircularProgressIndicator(
              value: percentage / 100,
              strokeWidth: 3.w,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Center(
            child: Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
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
