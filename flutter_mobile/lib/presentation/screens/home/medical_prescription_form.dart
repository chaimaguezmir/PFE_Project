// Full screen: MedicalPrescriptionForm (preserves original design, wired to cubit + pending treatments)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_treatment_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/reminder_time_entity.dart';
import 'package:flutter_mobile/domain/entities/services/my_medicine_entity.dart';
import 'package:flutter_mobile/presentation/bloc/home/prescription_creation_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/home/welcome_screen_cubit.dart';
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

class MedicalPrescriptionForm extends StatefulWidget {
  const MedicalPrescriptionForm({super.key});

  @override
  State<MedicalPrescriptionForm> createState() =>
      _MedicalPrescriptionFormState();
}

class _MedicalPrescriptionFormState extends State<MedicalPrescriptionForm> {
  late final TextEditingController _treatmentNameController;
  String? _selectedDiseaseType;

  // Fallback sample list for display when no medicines available
  final List<MedicationData> _sampleMedications = [
    MedicationData(
      name: 'Aminofer',
      duration: '7 jours',
      instructions: 'Une seule prise après repas',
      percentage: 51,
    ),
    MedicationData(
      name: 'Paracétamol',
      duration: '5 jours',
      instructions: 'Trois fois par jour',
      percentage: 75,
    ),
  ];

  @override
  void initState() {
    super.initState();
    final cubit = context.read<PrescriptionCreationCubit>();
    // Initialize controller with value from cubit state
    _treatmentNameController = TextEditingController(
      text: cubit.state.prescriptionForm.name,
    );

    // When typing, update cubit
    _treatmentNameController.addListener(() {
      final value = _treatmentNameController.text;
      cubit.setPrescriptionFormData(name: value);
    });

    // Initialize the creation flow (resets statuses if needed)
    cubit.initializePrescriptionCreation();
  }

  @override
  void dispose() {
    _treatmentNameController.dispose();
    super.dispose();
  }

  void _onAddTreatmentPressed() {
    // Navigate to treatment screen to add a pending treatment
    context.pushNamed(AppRouteName.treatmentForm);
  }

  void _onValidatePressed() {
    // Trigger the cubit flow that creates prescription -> treatments -> reminders
    context.read<PrescriptionCreationCubit>().createPrescriptionWithPending();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Ajouter Une prescription'),
      body: BlocListener<PrescriptionCreationCubit, PrescriptionCreationState>(
        listener: (context, state) {
          // Show errors from cubit
          if (state.prescriptionStatus == FormzSubmissionStatus.failure &&
              state.prescriptionErrorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.prescriptionErrorMessage!)),
            );
          }

          if (state.reminderStatus == FormzSubmissionStatus.failure &&
              state.reminderErrorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.reminderErrorMessage!)),
            );
          }

          if (state.treatmentStatus == FormzSubmissionStatus.failure &&
              state.treatmentErrorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.treatmentErrorMessage!)),
            );
          }

          // On success, clear local inputs if needed (cubit handles it)
          if (state.prescriptionStatus == FormzSubmissionStatus.success &&
              state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.successMessage!)),
            );
            // Optionally navigate away if creation completed
            // Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
        child: BlocBuilder<PrescriptionCreationCubit, PrescriptionCreationState>(
          builder: (context, state) {
            _selectedDiseaseType = state.prescriptionForm.diseaseIds.isNotEmpty
                ? state.prescriptionForm.diseaseIds.first
                : _selectedDiseaseType;

            // Use medicines from cubit if available for display in the list
            final List<MedicationData> medsToShow =
            (state.filteredMedicines.isNotEmpty
                ? state.filteredMedicines
                : state.availableMedicines)
                .map(
                  (m) => MedicationData(
                name: (m as MyMedicineEntity).name ?? 'Médicament',
                duration: 'À définir',
                instructions: m.manufacturerName ?? '',
                percentage: 0,
              ),
            )
                .toList();

            final medications = medsToShow.isNotEmpty
                ? medsToShow
                : _sampleMedications;

            // Build UI (preserves original design)
            return Column(
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
                            // Treatment Name Input (unchanged visually)
                            TreatmentNameInput(
                              controller: _treatmentNameController,
                              onChanged: (value) {
                                // already handled by controller listener; keep for compatibility
                                context
                                    .read<PrescriptionCreationCubit>()
                                    .setPrescriptionFormData(name: value);
                              },
                            ),

                            SizedBox(height: 20.h),

                            // Disease Type Dropdown
                            CustomDropdown(
                              hintText: 'Type de Maladie',
                              items: const [
                                'd3725d7d-23f7-41ea-8277-e7a8bceedfc2',
                                'Hypertension',
                                'Migraine',
                                'Allergie',
                                'Infection',
                              ],
                              value: _selectedDiseaseType,
                              onChanged: (value) {
                                if (value != null) {
                                  context
                                      .read<PrescriptionCreationCubit>()
                                      .setPrescriptionFormData(
                                    diseaseIds: [value],
                                  );
                                }
                              },
                            ),

                            SizedBox(height: 20.h),

                            // Add Treatment Button (renamed / changed behavior)
                            AddPrescriptionButton(
                              onPressed: _onAddTreatmentPressed,
                            ),

                            SizedBox(height: 10.h),
                          ],
                        ),
                      ),

                      // Medications List Section (unchanged visual)
                      Expanded(child: MedicationsList(medications: medications)),

                      // Pending treatments preview + Validate button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            // Pending treatments summary (shows count and simple list)
                            if (state.pendingTreatments.isNotEmpty) ...[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Traitements ajoutés (${state.pendingTreatments.length})',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Column(
                                  children: List.generate(state.pendingTreatments.length, (i) {
                                    final t = state.pendingTreatments[i];
                                    final remindersCount = i < state.pendingReminders.length
                                        ? state.pendingReminders[i].length
                                        : 0;
                                    return ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        t.myMedicineId.isNotEmpty ? t.myMedicineId : (t.dosage.isNotEmpty ? t.dosage : 'Traitement ${i + 1}'),
                                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text('Rappels: $remindersCount'),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete_outline, size: 20.sp),
                                        onPressed: () {
                                          context.read<PrescriptionCreationCubit>().removePendingTreatment(i);
                                        },
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              SizedBox(height: 12.h),
                            ],

                            // Validate button (only enabled when all pending treatments have at least one reminder)
                            ValidateButton(
                              onPressed: state.canCreatePrescriptionWithPending
                                  ? _onValidatePressed
                                  : null,
                              text: 'Valider la prescription',
                              isEnabled: state.canCreatePrescriptionWithPending &&
                                  state.prescriptionStatus != FormzSubmissionStatus.inProgress,
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// -----------------------------
// Original widgets preserved (CustomAppBar, TreatmentNameInput, CustomDropdown, etc.)
// Copy your original widget implementations here verbatim (keeps visual design).
// For brevity they are included below - keep identical to your original file.
// -----------------------------

// Custom App Bar Widget matching your existing app bar design
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

// Treatment Name Input Widget with modern design matching login/signup
class TreatmentNameInput extends StatefulWidget {
  const TreatmentNameInput({super.key, this.controller, this.onChanged});
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  State<TreatmentNameInput> createState() => _TreatmentNameInputState();
}

class _TreatmentNameInputState extends State<TreatmentNameInput> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

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
      child: TextField(
        controller: _controller,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        onChanged: (value) {
          widget.onChanged?.call(value);
        },
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
              color: _hasText
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[300]!,
              width: _hasText ? 2.w : 1.w,
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

// Custom Dropdown Widget matching login/signup design
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

// Add Prescription Button Widget (used as "Ajouter Traitement")
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
            onTap: onPressed ?? () {},
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
          ? Container(
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
      )
          : ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: medications.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final medication = medications[index];
          return MedicationCard(
            name: medication.name,
            duration: medication.duration,
            instructions: medication.instructions,
            percentage: medication.percentage,
          );
        },
      ),
    );
  }
}

class MedicationCard extends StatelessWidget {
  const MedicationCard({
    super.key,
    required this.name,
    required this.duration,
    required this.instructions,
    required this.percentage,
  });
  final String name;
  final String duration;
  final String instructions;
  final int percentage;

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
          // Medication Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MedicationName(name: name),
                SizedBox(height: 8.h),
                MedicationDuration(duration: duration),
                SizedBox(height: 4.h),
                MedicationInstructions(instructions: instructions),
              ],
            ),
          ),

          SizedBox(width: 16.w),

          // Progress Circle
          PercentageBadge(percentage: percentage),
        ],
      ),
    );
  }
}

class MedicationName extends StatelessWidget {
  const MedicationName({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
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
          // Background Circle
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[200]!, width: 3.w),
            ),
          ),
          // Progress Circle
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
          // Progress Text
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

class MedicationDuration extends StatelessWidget {
  const MedicationDuration({super.key, required this.duration});
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Text(
      duration,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }
}

class MedicationInstructions extends StatelessWidget {
  const MedicationInstructions({super.key, required this.instructions});
  final String instructions;

  @override
  Widget build(BuildContext context) {
    return Text(
      instructions,
      style: TextStyle(
        fontSize: 14.sp,
        color: Colors.grey[600],
        fontWeight: FontWeight.w400,
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
        onPressed: isEnabled ? (onPressed ?? () {}) : null,
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