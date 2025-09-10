// Complete Stateless MedicalTreatmentForm with Cubit Integration
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/domain/entities/services/PharmacyBoxEntity.dart';
import 'package:flutter_mobile/domain/entities/services/my_medicine_entity.dart';
import 'package:flutter_mobile/presentation/bloc/home/prescription_creation_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/home/welcome_screen_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TreatmentFormData {
  final String selectedBox;
  final String selectedMedicineId;
  final int selectedDosage;
  final String selectedFrequency;
  final int selectedDurationDays;
  final Set<String> selectedMoments;
  final String selectedMealTiming;
  final String searchQuery;

  const TreatmentFormData({
    this.selectedBox = '',
    this.selectedMedicineId = '',
    this.selectedDosage = 1,
    this.selectedFrequency = 'Chaque jour',
    this.selectedDurationDays = 30,
    this.selectedMoments = const {'Matin', 'Après Midi'},
    this.selectedMealTiming = 'Avant repas',
    this.searchQuery = '',
  });

  TreatmentFormData copyWith({
    String? selectedBox,
    String? selectedMedicineId,
    int? selectedDosage,
    String? selectedFrequency,
    int? selectedDurationDays,
    Set<String>? selectedMoments,
    String? selectedMealTiming,
    String? searchQuery,
  }) {
    return TreatmentFormData(
      selectedBox: selectedBox ?? this.selectedBox,
      selectedMedicineId: selectedMedicineId ?? this.selectedMedicineId,
      selectedDosage: selectedDosage ?? this.selectedDosage,
      selectedFrequency: selectedFrequency ?? this.selectedFrequency,
      selectedDurationDays: selectedDurationDays ?? this.selectedDurationDays,
      selectedMoments: selectedMoments ?? this.selectedMoments,
      selectedMealTiming: selectedMealTiming ?? this.selectedMealTiming,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class MedicalTreatmentForm extends StatefulWidget {
  const MedicalTreatmentForm({super.key, this.onConfirmTreatment});

  final VoidCallback? onConfirmTreatment;

  @override
  State<MedicalTreatmentForm> createState() => _MedicalTreatmentFormState();
}

class _MedicalTreatmentFormState extends State<MedicalTreatmentForm> {
  TreatmentFormData formData = const TreatmentFormData();

  @override
  void initState() {
    super.initState();
    // Fetch pharmacy boxes when the form loads
    context.read<PrescriptionCreationCubit>().fetchPharmacyBoxes();
  }

  void _updateFormData(TreatmentFormData newData) {
    setState(() {
      formData = newData;
    });
  }

  bool get _canConfirm {
    return formData.selectedBox.isNotEmpty &&
        formData.selectedMedicineId.isNotEmpty;
  }

  String _durationValueString(int days) => '$days jours';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrescriptionCreationCubit, PrescriptionCreationState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: 'Modifier Prescription'),
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
                        selectedBox: formData.selectedBox,
                        pharmacyBoxes: state.pharmacyBoxes,
                        isLoading:
                            state.pharmacyBoxesStatus ==
                            FormzSubmissionStatus.inProgress,
                        onChanged: (boxId) {
                          if (boxId != null && boxId != formData.selectedBox) {
                            _updateFormData(
                              formData.copyWith(
                                selectedBox: boxId,
                                selectedMedicineId:
                                    '', // Reset medicine selection
                              ),
                            );
                            // Fetch medicines for the selected box
                            context
                                .read<PrescriptionCreationCubit>()
                                .selectPharmacyBox(boxId);
                          }
                        },
                      ),
                      SizedBox(height: 20.h),
                      const _FormSectionLabel('Sélectionner Médicament'),
                      SizedBox(height: 8.h),
                      _MedicineDropdown(
                        selectedMedicineId: formData.selectedMedicineId,
                        medicines: state.medicines,
                        isLoading:
                            state.medicinesStatus ==
                            FormzSubmissionStatus.inProgress,
                        isEnabled: formData.selectedBox.isNotEmpty,
                        onChanged: (medicineId) {
                          if (medicineId != null) {
                            _updateFormData(
                              formData.copyWith(selectedMedicineId: medicineId),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 20.h),
                      const _FormSectionLabel('Dosage'),
                      SizedBox(height: 8.h),
                      _DosageCircleSelector(
                        selectedDosage: formData.selectedDosage,
                        onSelected: (dosage) {
                          _updateFormData(
                            formData.copyWith(selectedDosage: dosage),
                          );
                        },
                      ),
                      SizedBox(height: 16.h),
                      const _FormSectionLabel('Fréquence'),
                      SizedBox(height: 8.h),
                      _CustomDropdown(
                        hintText: 'Sélectionner la fréquence',
                        value: formData.selectedFrequency,
                        items: const [
                          'Chaque jour',
                          'Tous les 2 jours',
                          'Tous les 3 jours',
                        ],
                        onChanged: (frequency) {
                          if (frequency != null) {
                            _updateFormData(
                              formData.copyWith(selectedFrequency: frequency),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 20.h),
                      const _FormSectionLabel('Durée'),
                      SizedBox(height: 8.h),
                      _CustomDropdown(
                        hintText: 'Sélectionner la durée',
                        value: _durationValueString(
                          formData.selectedDurationDays,
                        ),
                        items: const ['7 jours', '30 jours', '60 jours'],
                        onChanged: (newValue) {
                          if (newValue != null) {
                            final days =
                                int.tryParse(newValue.split(' ').first) ?? 30;
                            _updateFormData(
                              formData.copyWith(selectedDurationDays: days),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 20.h),
                      const _FormSectionLabel('Moment de la journée'),
                      SizedBox(height: 12.h),
                      _MomentsSelector(
                        selectedMoments: formData.selectedMoments,
                        onChanged: (moments) {
                          _updateFormData(
                            formData.copyWith(selectedMoments: moments),
                          );
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
                        selectedMealTiming: formData.selectedMealTiming,
                        onSelected: (timing) {
                          if (timing != null) {
                            _updateFormData(
                              formData.copyWith(selectedMealTiming: timing),
                            );
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
                      text: 'Confirmer traitement',
                      onPressed: _canConfirm ? widget.onConfirmTreatment : null,
                      isEnabled: _canConfirm,
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
    // Debug prints
    print('🔧 _MedicineDropdown build:');
    print('  - isEnabled: $isEnabled');
    print('  - isLoading: $isLoading');
    print('  - medicines.length: ${medicines.length}');
    print('  - selectedMedicineId: $selectedMedicineId');

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

    print('🔧 Showing dropdown with ${medicines.length} medicines');
    for (final medicine in medicines) {
      print('  - ${medicine.name} (${medicine.id})');
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
