import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/presentation/bloc/services/services_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/simple_custom_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MedicationTrackerScreen extends StatelessWidget {
  const MedicationTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleCustomAppBar(
        title: 'Ajouter Un Médicament',
        onBack: () => context.pop(),
      ),
      body: const MedicationTrackerBody(),
    );
  }
}

class MedicationTrackerBody extends StatelessWidget {
  const MedicationTrackerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MedicationInfoCard(),
          SizedBox(height: 24.h),
          const ExpirationDateField(),
          SizedBox(height: 16.h),
          const QuantityField(),
          const Spacer(),
          const AddToBoxButton(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class MedicationInfoCard extends StatelessWidget {
  const MedicationInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      buildWhen: (previous, current) =>
      previous.scannedMedicine != current.scannedMedicine,
      builder: (context, state) {
        final medicine = state.scannedMedicine;

        if (medicine == null) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              'Aucun médicament sélectionné',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
          );
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.medication,
                  color: Colors.orange,
                  size: 30.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.name,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      medicine.dosageForm,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      medicine.manufacturer,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
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

class ExpirationDateField extends StatefulWidget {
  const ExpirationDateField({super.key});

  @override
  State<ExpirationDateField> createState() => _ExpirationDateFieldState();
}

class _ExpirationDateFieldState extends State<ExpirationDateField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final cubit = context.read<ServicesCubit>();
    final state = cubit.state;

    // Only allow date selection if medicine is scanned
    if (state.scannedMedicine == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez d\'abord scanner un médicament'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: state.selectedExpirationDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
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

    if (picked != null && mounted) {
      cubit.setExpirationDate(picked);
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServicesCubit, ServicesState>(
      listenWhen: (previous, current) =>
      previous.selectedExpirationDate != current.selectedExpirationDate ||
          previous.scannedMedicine != current.scannedMedicine,
      listener: (context, state) {
        if (state.selectedExpirationDate != null) {
          _controller.text = _formatDate(state.selectedExpirationDate!);
        } else {
          _controller.clear();
        }
      },
      child: BlocBuilder<ServicesCubit, ServicesState>(
        buildWhen: (previous, current) =>
        previous.scannedMedicine != current.scannedMedicine,
        builder: (context, state) {
          final isEnabled = state.scannedMedicine != null;

          return TextField(
            controller: _controller,
            readOnly: true,
            enabled: isEnabled,
            style: TextStyle(
              color: isEnabled ? Colors.black : Colors.grey[400],
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.calendar_today_outlined,
                color: isEnabled ? null : Colors.grey[400],
              ),
              labelText: 'Date d\'expiration',
              labelStyle: TextStyle(
                color: isEnabled ? null : Colors.grey[400],
              ),
              floatingLabelStyle: TextStyle(
                color: isEnabled ? theme().colorScheme.primary : Colors.grey[400],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(75.r)),
                borderSide: BorderSide(
                  color: isEnabled ? theme().colorScheme.tertiary : Colors.grey[300]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(75.r),
                borderSide: BorderSide(
                  color: theme().colorScheme.tertiary,
                  width: 1.w,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(75.r),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(75.r),
                borderSide: BorderSide(
                  color: theme().colorScheme.tertiary,
                  width: 1.w,
                ),
              ),
              filled: true,
              fillColor: isEnabled ? Colors.white : Colors.grey[50],
            ),
            onTap: isEnabled ? () => _selectDate(context) : null,
          );
        },
      ),
    );
  }
}

class QuantityField extends StatefulWidget {
  const QuantityField({super.key});

  @override
  State<QuantityField> createState() => _QuantityFieldState();
}

class _QuantityFieldState extends State<QuantityField> {
  late final TextEditingController _controller;
  bool _isUpdatingFromState = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleQuantityChange(String value, BuildContext context) {
    if (_isUpdatingFromState) return;

    final state = context.read<ServicesCubit>().state;
    if (state.scannedMedicine == null) return;

    if (value.isEmpty) {
      context.read<ServicesCubit>().setQuantity(0);
    } else {
      final quantity = int.tryParse(value);
      if (quantity != null && quantity >= 0) {
        context.read<ServicesCubit>().setQuantity(quantity);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServicesCubit, ServicesState>(
      listenWhen: (previous, current) =>
      previous.selectedQuantity != current.selectedQuantity ||
          previous.scannedMedicine != current.scannedMedicine,
      listener: (context, state) {
        _isUpdatingFromState = true;

        if (state.scannedMedicine == null) {
          _controller.clear();
        } else if (state.selectedQuantity > 0) {
          _controller.text = state.selectedQuantity.toString();
        } else if (state.selectedQuantity == 0 && _controller.text.isNotEmpty) {
          // Only clear if we explicitly want to reset, not during typing
          final currentValue = int.tryParse(_controller.text) ?? 0;
          if (currentValue == 0) {
            _controller.clear();
          }
        }

        _isUpdatingFromState = false;
      },
      child: BlocBuilder<ServicesCubit, ServicesState>(
        buildWhen: (previous, current) =>
        previous.scannedMedicine != current.scannedMedicine,
        builder: (context, state) {
          final isEnabled = state.scannedMedicine != null;

          return TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            enabled: isEnabled,
            style: TextStyle(
              color: isEnabled ? Colors.black : Colors.grey[400],
            ),
            onChanged: (value) => _handleQuantityChange(value, context),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.numbers,
                color: isEnabled ? null : Colors.grey[400],
              ),
              labelText: 'Quantité',
              labelStyle: TextStyle(
                color: isEnabled ? null : Colors.grey[400],
              ),
              floatingLabelStyle: TextStyle(
                color: isEnabled ? theme().colorScheme.primary : Colors.grey[400],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(75.r)),
                borderSide: BorderSide(
                  color: isEnabled ? theme().colorScheme.tertiary : Colors.grey[300]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(75.r),
                borderSide: BorderSide(
                  color: theme().colorScheme.tertiary,
                  width: 1.w,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(75.r),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(75.r),
                borderSide: BorderSide(
                  color: theme().colorScheme.primary,
                  width: 1.w,
                ),
              ),
              filled: true,
              fillColor: isEnabled ? Colors.white : Colors.grey[50],
            ),
          );
        },
      ),
    );
  }
}

class AddToBoxButton extends StatelessWidget {
  const AddToBoxButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServicesCubit, ServicesState>(
      listener: (context, state) {
        if (state.isSuccess && state.hasSuccess) {
          _showSuccessDialog(context, state);
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
      child: BlocBuilder<ServicesCubit, ServicesState>(
        buildWhen: (previous, current) =>
        previous.selectedExpirationDate != current.selectedExpirationDate ||
            previous.selectedQuantity != current.selectedQuantity ||
            previous.scannedMedicine != current.scannedMedicine ||
            previous.status != current.status,
        builder: (context, state) {
          final isEnabled = state.canAddMedicine && !state.isLoading;
          final isLoading = state.isLoading;

          return Container(
            width: double.infinity,
            height: 50.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: isEnabled
                    ? theme().colorScheme.secondary
                    : Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: ElevatedButton(
              onPressed: isEnabled
                  ? () => context.read<ServicesCubit>().addCurrentMedicineToCurrentBox()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme().colorScheme.secondary,
                  ),
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ajouter à Votre boîte',
                    style: TextStyle(
                      color: isEnabled
                          ? theme().colorScheme.secondary
                          : Colors.grey[400],
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: isEnabled
                          ? theme().colorScheme.secondary
                          : Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, ServicesState state) {
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
                '${state.scannedMedicine?.name ?? "Le médicament"} a été ajouté à votre boîte de pharmacie avec ${state.selectedQuantity} unité(s).',
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
                        // Close dialog first
                        context.pop();
                        context.read<ServicesCubit>().clearScannedMedicine();
                        // Then navigate to barcode scanner
                        context.goNamed(AppRouteName.barcodeScanner);
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
                        context.pop();
                        context.goNamed(AppRouteName.pharmacyBox);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme().colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'Voir la boîte',
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