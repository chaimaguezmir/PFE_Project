// User Medical Prescription Form that uses UserPrescriptionCreationCubit
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_treatment_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/treatment_entity.dart';
import 'package:flutter_mobile/domain/entities/reminder/simple_create_reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/reminder/simple_reminder_time_entity.dart';
import 'package:flutter_mobile/presentation/bloc/group/group_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/user_management/user_prescription_creation_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';

class UserMedicalPrescriptionForm extends StatefulWidget {
  const UserMedicalPrescriptionForm({super.key});

  @override
  State<UserMedicalPrescriptionForm> createState() => _UserMedicalPrescriptionFormState();
}

class _UserMedicalPrescriptionFormState extends State<UserMedicalPrescriptionForm> {
  @override
  void initState() {
    super.initState();
    // Initialize with group and user context from GroupCubit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final groupState = context.read<GroupCubit>().state;
      final groupId = groupState.currentGroupId;
      final userId = groupState.selectedMemberId;

      if (groupId.isNotEmpty && userId.isNotEmpty) {
        context.read<UserPrescriptionCreationCubit>().setUserAndGroup(userId, groupId);
        // Fetch diseases for the dropdown
        context.read<UserPrescriptionCreationCubit>().fetchDiseases();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPrescriptionCreationCubit, UserPrescriptionCreationState>(
      builder: (context, state) {
        final cubit = context.read<UserPrescriptionCreationCubit>();
        final hasName = state.name.isNotEmpty;
        final hasDisease = state.selectedDiseaseId != null && state.selectedDiseaseId!.isNotEmpty;
        final hasAtLeastOneTreatment = state.treatments.isNotEmpty;
        final enableValidateButton = hasName && hasDisease && hasAtLeastOneTreatment;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: 'Ajouter Une Prescription'),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Prescription Name
                      _TreatmentNameInput(
                        value: state.name,
                        onChanged: cubit.updateName,
                      ),
                      SizedBox(height: 20.h),

                      // Disease Type Dropdown
                      _CustomDropdown(
                        hintText: 'Type de Maladie',
                        value: state.selectedDiseaseId != null && state.selectedDiseaseId!.isNotEmpty
                            ? state.diseases.firstWhere(
                                (d) => d.id == state.selectedDiseaseId,
                                orElse: () => state.diseases.first,
                              ).name
                            : null,
                        items: state.diseases.map((disease) => disease.name).toList(),
                        onChanged: (diseaseName) {
                          if (diseaseName == null) return;
                          final disease = state.diseases.firstWhere((d) => d.name == diseaseName);
                          cubit.updateSelectedDiseaseId(disease.id);
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Add Treatment Button
                      _AddTreatmentButton(
                        onPressed: () {
                          context.pushNamed(AppRouteName.userManagementTreatmentForm);
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Treatments List
                      if (state.treatments.isNotEmpty) ...[
                        Text(
                          'Traitements (${state.treatments.length})',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        ...state.treatments.map((treatment) => _TreatmentCard(
                          medicineName: treatment['medicineName'] ?? 'Médicament',
                          dosage: '${treatment['dosage'] ?? 1}',
                          frequency: treatment['frequency'] ?? '',
                          durationDays: treatment['durationDays'] ?? 0,
                        )),
                      ],
                    ],
                  ),
                ),
              ),

              // Validate Button
              Padding(
                padding: EdgeInsets.all(20.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: enableValidateButton
                        ? () async {
                            final scaffold = ScaffoldMessenger.of(context);
                            final navigator = Navigator.of(context);
                            final savedTreatments = List<Map<String, dynamic>>.from(state.treatments);

                            try {
                              scaffold.showSnackBar(
                                const SnackBar(content: Text('Création de la prescription...')),
                              );

                              // 1) Create prescription
                              final prescriptionResult = await cubit.createPrescription();

                              if (prescriptionResult.data == null) {
                                scaffold.showSnackBar(
                                  SnackBar(
                                    content: Text(prescriptionResult.error ?? 'Erreur lors de la création de la prescription'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              final createdPrescriptionId = prescriptionResult.data!.id;
                              print('✅ Prescription created with ID: $createdPrescriptionId');

                              // 2) Create treatments for this prescription
                              final treatmentResults = await cubit.createTreatmentsForPrescription(
                                createdPrescriptionId,
                                savedTreatments,
                              );

                              // 3) Create reminders for each successful treatment
                              final List<String> failedReminders = [];
                              int successfulReminders = 0;

                              for (int i = 0; i < treatmentResults.length; i++) {
                                final treatmentResult = treatmentResults[i];
                                final savedTreatment = savedTreatments[i];

                                if (treatmentResult is DataSuccess<TreatmentEntity>) {
                                  final createdTreatment = treatmentResult.data!;

                                  // Extract reminder data
                                  final List<dynamic> moments = (savedTreatment['moments'] as List<dynamic>?) ?? [];
                                  final String mealTiming = (savedTreatment['mealTiming'] as String?) ?? 'après repas';

                                  if (moments.isNotEmpty) {
                                    // Convert moments to reminder times
                                    final List<SimpleReminderTimeEntity> reminderTimes = [];

                                    for (final moment in moments) {
                                      final momentStr = moment.toString().toLowerCase().trim();

                                      String timeSlot;
                                      String defaultTime;

                                      if (momentStr.contains('matin')) {
                                        timeSlot = 'MORNING';
                                        defaultTime = '08:00';
                                      } else if (momentStr.contains('aprè') || momentStr.contains('midi')) {
                                        timeSlot = 'NOON';
                                        defaultTime = '12:00';
                                      } else if (momentStr.contains('soir')) {
                                        timeSlot = 'EVENING';
                                        defaultTime = '18:00';
                                      } else if (momentStr.contains('nuit')) {
                                        timeSlot = 'NIGHT';
                                        defaultTime = '21:00';
                                      } else {
                                        timeSlot = 'MORNING';
                                        defaultTime = '08:00';
                                      }

                                      reminderTimes.add(
                                        SimpleReminderTimeEntity(
                                          timeSlot: timeSlot,
                                          time: defaultTime,
                                        ),
                                      );
                                    }

                                    // Remove duplicates
                                    final uniqueTimes = <String, SimpleReminderTimeEntity>{};
                                    for (final rt in reminderTimes) {
                                      uniqueTimes[rt.timeSlot] = rt;
                                    }

                                    if (uniqueTimes.isNotEmpty) {
                                      final customMessage = 'Prendre ${createdTreatment.myMedicine.name} - $mealTiming';

                                      final simpleReminder = SimpleCreateReminderEntity(
                                        treatmentId: createdTreatment.id,
                                        reminderTimes: uniqueTimes.values.toList(),
                                        customMessage: customMessage,
                                        startPreference: 'START_NEXT_CYCLE',
                                      );

                                      if (simpleReminder.isValid) {
                                        final remindersResult = await cubit.createSimpleReminders(simpleReminder);

                                        if (remindersResult is DataSuccess) {
                                          successfulReminders++;
                                          print('✅ Reminders created for treatment ${createdTreatment.id}');
                                        } else {
                                          failedReminders.add(createdTreatment.myMedicine.name);
                                          print('❌ Failed to create reminders for ${createdTreatment.myMedicine.name}');
                                        }
                                      }
                                    }
                                  }
                                }
                              }

                              // Show success message
                              scaffold.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Prescription créée avec succès! $successfulReminders rappel(s) créé(s)',
                                  ),
                                ),
                              );
                              navigator.pop();

                            } catch (e) {
                              scaffold.showSnackBar(
                                SnackBar(
                                  content: Text('Erreur: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      disabledBackgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                    ),
                    child: Text(
                      'Valider',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddTreatmentButton extends StatelessWidget {
  const _AddTreatmentButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 2.sp),
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ajouter Traitement',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.white, size: 16.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class _TreatmentCard extends StatelessWidget {
  const _TreatmentCard({
    required this.medicineName,
    required this.dosage,
    required this.frequency,
    required this.durationDays,
  });

  final String medicineName;
  final String dosage;
  final String frequency;
  final int durationDays;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            medicineName,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Dosage: $dosage • $frequency',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          Text(
            'Durée: $durationDays jours',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _TreatmentNameInput extends StatelessWidget {
  const _TreatmentNameInput({required this.value, this.onChanged});

  final String value;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: value)..selection = TextSelection.fromPosition(TextPosition(offset: value.length)),
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'Nom Traitement',
        floatingLabelStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
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
            color: value.isNotEmpty ? Theme.of(context).colorScheme.primary : Colors.grey[300]!,
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
      ),
    );
  }
}

class _CustomDropdown extends StatelessWidget {
  const _CustomDropdown({
    required this.hintText,
    required this.items,
    this.value,
    this.onChanged,
  });

  final String hintText;
  final List<String> items;
  final String? value;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hintText,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: hintText,
            floatingLabelStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
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
          ),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
