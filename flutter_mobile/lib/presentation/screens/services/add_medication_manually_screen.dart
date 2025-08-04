import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/domain/entities/services/medicine_entity.dart';
import 'package:flutter_mobile/presentation/bloc/services/services_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/simple_custom_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AddMedicationManuallyScreen extends StatelessWidget {
  const AddMedicationManuallyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch all medicines when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServicesCubit>().fetchAllMedicines();
    });

    return Scaffold(
      appBar: SimpleCustomAppBar(
        title: 'Ajouter Un Médicament',
        onBack: () {
          // Clear form data when leaving screen
          context.read<ServicesCubit>().clearManualMedicationData();
          context.pop();
        },
      ),
      body: const AddMedicationBody(),
    );
  }
}

class AddMedicationBody extends StatelessWidget {
  const AddMedicationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServicesCubit, ServicesState>(
      listener: (context, state) {
        if (state.isSuccess && state.hasSuccess) {
          _showSuccessDialog(context);
        }

        if (state.isFailure && state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Informations du médicament',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Remplissez les informations ci-dessous',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 32.h),

            // Form Fields Section
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MedicationNameField(),
                    SizedBox(height: 20),
                    MedicationFormDropdown(),
                    SizedBox(height: 20),
                    QuantityDropdown(),
                    SizedBox(height: 20),
                    ExpirationDateField(),
                  ],
                ),
              ),
            ),

            // Confirm Button
            const ConfirmButton(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 30.sp,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Médicament ajouté avec succès !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Le médicament a été ajouté à votre boîte de pharmacie.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  height: 1.3,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.pop(); // Close dialog
                        context.read<ServicesCubit>().clearManualMedicationData();
                        // Stay on same screen to add another
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: theme().colorScheme.secondary,
                          width: 1.5.w,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'Ajouter un autre',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: theme().colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.pop(); // Close dialog
                        context.pop(); // Go back to previous screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme().colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'Terminer',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MedicationNameField extends StatefulWidget {
  const MedicationNameField({super.key});

  @override
  State<MedicationNameField> createState() => _MedicationNameFieldState();
}

class _MedicationNameFieldState extends State<MedicationNameField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showSuggestionsOverlay();
      } else {
        _hideSuggestionsOverlay();
      }
    });
  }

  @override
  void dispose() {
    _hideSuggestionsOverlay();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showSuggestionsOverlay() {
    _hideSuggestionsOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 40.w,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, 60.h),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(12.r),
            child: BlocBuilder<ServicesCubit, ServicesState>(
              buildWhen: (previous, current) =>
              previous.filteredMedicinesForSearch != current.filteredMedicinesForSearch ||
                  previous.medicineSearchStatus != current.medicineSearchStatus,
              builder: (context, state) {
                if (state.isMedicineSearchLoading) {
                  return Container(
                    height: 100.h,
                    padding: EdgeInsets.all(16.w),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                if (state.filteredMedicinesForSearch.isEmpty) {
                  return Container(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      'Aucun médicament trouvé',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }

                return Container(
                  constraints: BoxConstraints(maxHeight: 200.h),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.filteredMedicinesForSearch.length,
                    itemBuilder: (context, index) {
                      final medicine = state.filteredMedicinesForSearch[index];
                      return ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.medication,
                          color: theme().colorScheme.secondary,
                          size: 20.sp,
                        ),
                        title: Text(
                          medicine.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          '${medicine.dosageForm} - ${medicine.manufacturer}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        onTap: () {
                          _selectMedicine(medicine);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _showSuggestions = true;
    });
  }

  void _hideSuggestionsOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _showSuggestions = false;
    });
  }

  void _selectMedicine(MedicineEntity medicine) {
    _controller.text = medicine.name;
    context.read<ServicesCubit>().selectMedicineForManualAdd(medicine);
    context.read<ServicesCubit>().setManualMedicationData(
      name: medicine.name,
      form: medicine.dosageForm,
    );
    _hideSuggestionsOverlay();
    _focusNode.unfocus();
  }

  final LayerLink _layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServicesCubit, ServicesState>(
      listenWhen: (previous, current) =>
      previous.selectedMedicineForManualAdd != current.selectedMedicineForManualAdd,
      listener: (context, state) {
        if (state.selectedMedicineForManualAdd != null && _controller.text.isEmpty) {
          _controller.text = state.selectedMedicineForManualAdd!.name;
        }
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: BlocBuilder<ServicesCubit, ServicesState>(
          buildWhen: (previous, current) =>
          previous.medicineSearchStatus != current.medicineSearchStatus,
          builder: (context, state) {
            return TextField(
              controller: _controller,
              focusNode: _focusNode,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black87,
              ),
              onChanged: (value) {
                context.read<ServicesCubit>().searchMedicinesByName(value);
                context.read<ServicesCubit>().setManualMedicationData(name: value);

                // Clear selected medicine if user types something different
                final currentSelected = context.read<ServicesCubit>().state.selectedMedicineForManualAdd;
                if (currentSelected != null && currentSelected.name != value) {
                  context.read<ServicesCubit>().clearSelectedMedicineForManualAdd();
                }
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.local_pharmacy_outlined,
                  color: theme().colorScheme.onTertiary,
                ),
                suffixIcon: state.isMedicineSearchLoading
                    ? Padding(
                  padding: EdgeInsets.all(12.w),
                  child: SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme().colorScheme.secondary,
                      ),
                    ),
                  ),
                )
                    : null,
                labelText: 'Nom Médicament',
                labelStyle: TextStyle(
                  fontSize: 16.sp,
                  color: theme().colorScheme.onTertiary,
                ),
                floatingLabelStyle: TextStyle(color: theme().colorScheme.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(75.r)),
                  borderSide: BorderSide(color: theme().colorScheme.tertiary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(75.r),
                  borderSide: BorderSide(
                    color: theme().colorScheme.tertiary,
                    width: 2.w,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(75.r),
                  borderSide: BorderSide(
                    color: theme().colorScheme.primary,
                    width: 2.w,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MedicationFormDropdown extends StatefulWidget {
  const MedicationFormDropdown({super.key});

  @override
  State<MedicationFormDropdown> createState() => _MedicationFormDropdownState();
}

class _MedicationFormDropdownState extends State<MedicationFormDropdown> {
  final List<String> medicationForms = [
    'Comprimé',
    'Gélule',
    'Sirop',
    'Gouttes',
    'Injection',
    'Pommade',
    'Spray',
    'Suppositoire',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      buildWhen: (previous, current) =>
      previous.autoFilledForm != current.autoFilledForm ||
          previous.manualMedicationForm != current.manualMedicationForm,
      builder: (context, state) {
        // Use auto-filled form if available, otherwise use manual form
        String? selectedForm = state.autoFilledForm.isNotEmpty
            ? state.autoFilledForm
            : (state.manualMedicationForm.isNotEmpty ? state.manualMedicationForm : null);

        return DropdownButtonFormField<String>(
          value: selectedForm,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.medication_outlined,
              color: theme().colorScheme.onTertiary,
            ),
            labelText: 'Forme Médicament',
            labelStyle: TextStyle(
              fontSize: 16.sp,
              color: theme().colorScheme.onTertiary,
            ),
            floatingLabelStyle: TextStyle(color: theme().colorScheme.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(75.r)),
              borderSide: BorderSide(color: theme().colorScheme.tertiary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(75.r),
              borderSide: BorderSide(
                color: theme().colorScheme.tertiary,
                width: 2.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(75.r),
              borderSide: BorderSide(
                color: theme().colorScheme.primary,
                width: 2.w,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: theme().colorScheme.onTertiary,
          ),
          isExpanded: true,
          items: medicationForms.map((String form) {
            return DropdownMenuItem<String>(
              value: form,
              child: Text(
                form,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              context.read<ServicesCubit>().setManualMedicationData(form: newValue);
            }
          },
        );
      },
    );
  }
}

class QuantityDropdown extends StatefulWidget {
  const QuantityDropdown({super.key});

  @override
  State<QuantityDropdown> createState() => _QuantityDropdownState();
}

class _QuantityDropdownState extends State<QuantityDropdown> {
  final List<int> quantities = [1, 2, 3, 4, 5, 10, 15, 20, 30, 50, 100];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      buildWhen: (previous, current) =>
      previous.manualMedicationQuantity != current.manualMedicationQuantity,
      builder: (context, state) {
        int? selectedQuantity = state.manualMedicationQuantity > 0
            ? state.manualMedicationQuantity
            : null;

        return DropdownButtonFormField<int>(
          value: selectedQuantity,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.numbers_outlined,
              color: theme().colorScheme.onTertiary,
            ),
            labelText: 'Quantité',
            labelStyle: TextStyle(
              fontSize: 16.sp,
              color: theme().colorScheme.onTertiary,
            ),
            floatingLabelStyle: TextStyle(color: theme().colorScheme.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(75.r)),
              borderSide: BorderSide(color: theme().colorScheme.tertiary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(75.r),
              borderSide: BorderSide(
                color: theme().colorScheme.tertiary,
                width: 2.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(75.r),
              borderSide: BorderSide(
                color: theme().colorScheme.primary,
                width: 2.w,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: theme().colorScheme.onTertiary,
          ),
          isExpanded: true,
          items: quantities.map((int quantity) {
            return DropdownMenuItem<int>(
              value: quantity,
              child: Text(
                '$quantity unité${quantity > 1 ? 's' : ''}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
          onChanged: (int? newValue) {
            if (newValue != null) {
              context.read<ServicesCubit>().setManualMedicationData(quantity: newValue);
            }
          },
        );
      },
    );
  }
}

class ExpirationDateField extends StatefulWidget {
  const ExpirationDateField({super.key});

  @override
  State<ExpirationDateField> createState() => _ExpirationDateFieldState();
}

class _ExpirationDateFieldState extends State<ExpirationDateField> {
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)), // 10 years from now
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: theme().colorScheme.secondary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateController.text = _formatDate(picked);
      });
      context.read<ServicesCubit>().setManualMedicationData(expirationDate: picked);
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _dateController,
      readOnly: true,
      style: TextStyle(
        fontSize: 16.sp,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.calendar_today_outlined,
          color: theme().colorScheme.onTertiary,
        ),
        labelText: 'Date d\'expiration',
        labelStyle: TextStyle(
          fontSize: 16.sp,
          color: theme().colorScheme.onTertiary,
        ),
        floatingLabelStyle: TextStyle(color: theme().colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(75.r)),
          borderSide: BorderSide(color: theme().colorScheme.tertiary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(75.r),
          borderSide: BorderSide(
            color: theme().colorScheme.tertiary,
            width: 2.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(75.r),
          borderSide: BorderSide(
            color: theme().colorScheme.primary,
            width: 2.w,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
      ),
      onTap: () => _selectDate(context),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      buildWhen: (previous, current) =>
      previous.canSubmitManualMedication != current.canSubmitManualMedication ||
          previous.status != current.status,
      builder: (context, state) {
        final isEnabled = state.canSubmitManualMedication && !state.isLoading;
        final isLoading = state.isLoading;

        return Container(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: isEnabled
                ? () => context.read<ServicesCubit>().addManualMedicationToPharmacyBox()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme().colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
              elevation: 2,
            ),
            child: isLoading
                ? SizedBox(
              width: 20.w,
              height: 20.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Text(
              'Confirmer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}