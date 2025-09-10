// Full screen: MedicalTreatmentForm (preserves original design, wired to cubit + multi-select moments and default times)
// Fix: duration dropdown values now match the value string formatting to avoid Dropdown assertion.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/domain/entities/prescription/create_treatment_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/reminder_time_entity.dart';
import 'package:flutter_mobile/domain/entities/services/my_medicine_entity.dart';
import 'package:flutter_mobile/presentation/bloc/home/prescription_creation_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicalTreatmentForm extends StatefulWidget {
  const MedicalTreatmentForm({super.key});

  @override
  State<MedicalTreatmentForm> createState() => _MedicalTreatmentFormState();
}

class _MedicalTreatmentFormState extends State<MedicalTreatmentForm> {
  String? _selectedBox;
  String? _selectedMedicineId;
  int _selectedDosage = 1;
  String? _selectedFrequency;
  int? _selectedDurationDays;
  Set<String> _selectedMoments = {};
  String _selectedMealTiming = 'Avant repas';
  final TextEditingController _searchController = TextEditingController();

  // default times for moments
  static const Map<String, String> defaultMomentTimes = {
    'Matin': '08:00',
    'Après Midi': '12:00',
    'Soir': '20:00',
    'Nuit': '22:00',
  };

  @override
  void initState() {
    super.initState();
    _selectedBox = 'Boite 1';
    _selectedFrequency = 'Chaque jour';
    _selectedDurationDays = 30;
    // default selected moments: Matin, Après Midi
    _selectedMoments = {'Matin', 'Après Midi'};
    _searchController.addListener(() {
      context.read<PrescriptionCreationCubit>().searchMedicines(
        _searchController.text,
      );
    });

    // Optionally fetch medicines if needed (example pharmacyBoxId can be passed via args)
    // context.read<PrescriptionCreationCubit>().fetchAvailableMedicines('defaultBoxId');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _canConfirmTreatment {
    // require at least one selected moment and non-zero dosage/duration
    final hasMoments = _selectedMoments.isNotEmpty;
    final hasDuration =
        (_selectedDurationDays != null && _selectedDurationDays! > 0);
    final hasDosage = _selectedDosage > 0;
    // We don't strictly require selectedMedicineId here because the user might pick from search results;
    // the cubit will validate on creation if necessary.
    return hasMoments && hasDuration && hasDosage;
  }

  void _onConfirmTreatment() {
    if (!_canConfirmTreatment) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez compléter le traitement et ajouter au moins un horaire',
          ),
        ),
      );
      return;
    }

    final createTreatment = CreateTreatmentEntity(
      prescriptionId: '', // will be filled when prescription is created
      myMedicineId: _selectedMedicineId ?? '',
      dosage: _selectedDosage.toString(),
      frequency: _selectedFrequency ?? '',
      durationDays: _selectedDurationDays ?? 0,
    );

    // Build ReminderTimeEntity list using selected moments and default times
    final reminders = _selectedMoments.map((momentLabel) {
      final slot = _mapMomentToSlot(momentLabel);
      final time = defaultMomentTimes[momentLabel] ?? '08:00';
      return ReminderTimeEntity(timeSlot: slot, time: time);
    }).toList();

    // Add pending treatment to cubit
    context.read<PrescriptionCreationCubit>().addPendingTreatment(
      createTreatment,
      reminders,
    );

    // Pop back to prescription screen
    Navigator.of(context).pop();
  }

  String _mapMomentToSlot(String label) {
    switch (label) {
      case 'Matin':
        return 'MORNING';
      case 'Après Midi':
        return 'AFTERNOON';
      case 'Soir':
        return 'EVENING';
      case 'Nuit':
        return 'NIGHT';
      default:
        return label.toUpperCase();
    }
  }

  String _durationValueString(int? days) {
    if (days == null) return '';
    // Use plural form matching dropdown items below
    return '$days jours';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Modifier Prescription'),
      body: BlocBuilder<PrescriptionCreationCubit, PrescriptionCreationState>(
        builder: (context, state) {
          final cubit = context.read<PrescriptionCreationCubit>();
          final medicines = state.filteredMedicines.isNotEmpty
              ? state.filteredMedicines
              : state.availableMedicines;

          // Resolve selected medicine safely (avoid returning null from orElse)
          MyMedicineEntity? selectedMedicine;
          if (_selectedMedicineId != null &&
              _selectedMedicineId!.isNotEmpty &&
              medicines.isNotEmpty) {
            try {
              final found = medicines.cast<MyMedicineEntity?>().firstWhere(
                (m) => m != null && m.id == _selectedMedicineId,
                orElse: () => null,
              );
              selectedMedicine = found;
            } catch (_) {
              selectedMedicine = medicines.isNotEmpty
                  ? (medicines.first as MyMedicineEntity)
                  : null;
            }
          } else {
            selectedMedicine = medicines.isNotEmpty
                ? (medicines.first as MyMedicineEntity)
                : null;
          }

          final medicineNameForField = selectedMedicine?.name ?? '';

          // Preselect first medicine id if not set
          if ((_selectedMedicineId == null || _selectedMedicineId!.isEmpty) &&
              selectedMedicine != null) {
            _selectedMedicineId = selectedMedicine.id;
          }

          return Column(
            children: [
              SizedBox(height: 20.h),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FormSectionLabel('Nom de la boite'),
                      SizedBox(height: 8.h),
                      _CustomDropdown(
                        hintText: 'Sélectionner une boite',
                        value: _selectedBox,
                        items: const ['Boite 1', 'Boite 2', 'Boite 3'],
                        onChanged: (v) {
                          setState(() {
                            _selectedBox = v ?? _selectedBox;
                          });
                        },
                      ),

                      SizedBox(height: 20.h),

                      const _FormSectionLabel('Chercher Médicament'),
                      SizedBox(height: 8.h),
                      _MedicineTextField(
                        controller: _searchController,
                        value: medicineNameForField,
                        onChanged: (q) {
                          // already handled by controller listener, but keep for compatibility
                          cubit.searchMedicines(q);
                        },
                      ),

                      SizedBox(height: 20.h),

                      const _FormSectionLabel('Dosage'),
                      SizedBox(height: 8.h),
                      _DosageCircleSelector(
                        selectedDosage: _selectedDosage,
                        onSelected: (val) {
                          setState(() {
                            _selectedDosage = val;
                          });
                        },
                      ),

                      SizedBox(height: 16.h),

                      const _FormSectionLabel('Fréquence'),
                      SizedBox(height: 8.h),
                      _CustomDropdown(
                        hintText: 'Sélectionner la fréquence',
                        value: _selectedFrequency,
                        items: const [
                          'Chaque jour',
                          'Tous les 2 jours',
                          'Tous les 3 jours',
                        ],
                        onChanged: (newValue) {
                          setState(() {
                            _selectedFrequency = newValue ?? _selectedFrequency;
                          });
                        },
                      ),

                      SizedBox(height: 20.h),

                      const _FormSectionLabel('Durée'),
                      SizedBox(height: 8.h),

                      // IMPORTANT: items values must match the value string exactly.
                      // Use plural "jours" to match the _durationValueString formatting.
                      _CustomDropdown(
                        hintText: 'Sélectionner la durée',
                        value: _durationValueString(_selectedDurationDays),
                        items: const ['7 jours', '30 jours', '60 jours'],
                        onChanged: (newValue) {
                          if (newValue != null) {
                            final days =
                                int.tryParse(newValue.split(' ').first) ?? 30;
                            setState(() {
                              _selectedDurationDays = days;
                            });
                          }
                        },
                      ),

                      SizedBox(height: 20.h),

                      const _FormSectionLabel('Moment de la journée'),
                      SizedBox(height: 12.h),
                      // Multi-select chips for moments of day
                      Wrap(
                        spacing: 8.w,
                        children: ['Matin', 'Après Midi', 'Soir', 'Nuit'].map((
                          label,
                        ) {
                          final selected = _selectedMoments.contains(label);
                          return FilterChip(
                            label: Text(label),
                            selected: selected,
                            onSelected: (isOn) {
                              setState(() {
                                if (isOn)
                                  _selectedMoments.add(label);
                                else
                                  _selectedMoments.remove(label);
                              });
                            },
                            selectedColor: Theme.of(
                              context,
                            ).colorScheme.secondary,
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 16.h),

                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            // Optionally allow adding a custom time (not implemented here)
                          },
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
                        selectedMealTiming: _selectedMealTiming,
                        onSelected: (option) {
                          setState(() {
                            _selectedMealTiming = option;
                          });
                        },
                      ),

                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),

              // Bottom Button: Confirm treatment (adds to pending list)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    ValidateButton(
                      text: 'Confirmer traitement',
                      onPressed: _canConfirmTreatment
                          ? _onConfirmTreatment
                          : null,
                      isEnabled: _canConfirmTreatment,
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// --------------------
// Reused widgets preserved from original design (small adaptations to accept controllers / callbacks)
// --------------------

class _FormSectionLabel extends StatelessWidget {
  final String text;
  const _FormSectionLabel(this.text);

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
  final String hintText;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;

  const _CustomDropdown({
    required this.hintText,
    this.value,
    required this.items,
    this.onChanged,
  });

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

class _MedicineTextField extends StatelessWidget {
  final TextEditingController controller;
  final String value;
  final ValueChanged<String>? onChanged;

  const _MedicineTextField({
    required this.controller,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasText = controller.text.isNotEmpty || value.isNotEmpty;

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
        controller: controller,
        initialValue: null, // use controller
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: 'Chercher Médicament',
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
              color: hasText
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[300]!,
              width: hasText ? 2.w : 1.w,
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

class _DosageCircleSelector extends StatelessWidget {
  final int selectedDosage;
  final ValueChanged<int>? onSelected;

  const _DosageCircleSelector({required this.selectedDosage, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h, // Fixed height for the scrollable area
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(20, (index) {
            final dosage = index + 1;
            final isSelected = dosage == selectedDosage;

            return Container(
              margin: EdgeInsets.only(right: 12.w),
              child: GestureDetector(
                onTap: () {
                  onSelected?.call(dosage);
                },
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

class _TimeOfDayIconSelector extends StatelessWidget {
  final String selectedTime;
  final ValueChanged<String>? onSelected;

  const _TimeOfDayIconSelector({required this.selectedTime, this.onSelected});

  @override
  Widget build(BuildContext context) {
    final timeOptions = [
      {'icon': Icons.wb_sunny_outlined, 'label': 'Matin'},
      {'icon': Icons.wb_sunny, 'label': 'Après Midi'},
      {'icon': Icons.brightness_3_outlined, 'label': 'Soir'},
      {'icon': Icons.brightness_2_outlined, 'label': 'Nuit'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: timeOptions.map((option) {
        final isSelected = option['label'] == selectedTime;

        return GestureDetector(
          onTap: () {
            onSelected?.call(option['label'] as String);
          },
          child: Column(
            children: [
              Container(
                width: 55.w,
                height: 55.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.grey[200],
                ),
                child: Icon(
                  option['icon'] as IconData,
                  color: isSelected ? Colors.white : Colors.grey[600],
                  size: 24.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                option['label'] as String,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _MealTimingButtonSelector extends StatelessWidget {
  final String selectedMealTiming;
  final ValueChanged<String>? onSelected;

  const _MealTimingButtonSelector({
    required this.selectedMealTiming,
    this.onSelected,
  });

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
              onPressed: () {
                onSelected?.call(option);
              },
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
  final VoidCallback? onPressed;
  final String text;
  final bool isEnabled;

  const ValidateButton({
    super.key,
    this.onPressed,
    this.text = 'Validé',
    this.isEnabled = true,
  });

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

// Custom app bar copied from original to keep design consistent
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

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
