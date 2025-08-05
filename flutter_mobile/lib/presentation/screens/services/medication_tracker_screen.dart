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

    print('=== Date Selection Debug ===');
    print('Current scannedMedicine: ${state.scannedMedicine?.name}');
    print('Current scannedMedicineExpirationDate: ${state.scannedMedicineExpirationDate}');

    // Only allow date selection if medicine is scanned
    if (state.scannedMedicine == null) {
      print('No medicine scanned, showing snackbar');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez d\'abord scanner un médicament'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    print('Showing date picker...');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: state.scannedMedicineExpirationDate ?? DateTime.now().add(const Duration(days: 365)),
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

    print('Date picker result: $picked');

    if (picked != null && mounted) {
      print('Setting expiration date: $picked');
      // Use setExpirationDate which sets scannedMedicineExpirationDate
      cubit.setExpirationDate(picked);

      // Check the state immediately after setting
      final newState = cubit.state;
      print('State after setting date: ${newState.scannedMedicineExpirationDate}');
    } else {
      print('Date picker was cancelled or no date selected');
    }
    print('=== End Date Selection Debug ===');
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServicesCubit, ServicesState>(
      listenWhen: (previous, current) =>
      previous.scannedMedicineExpirationDate != current.scannedMedicineExpirationDate ||
          previous.scannedMedicine != current.scannedMedicine,
      listener: (context, state) {
        print('=== ExpirationDateField Listener ===');
        print('Previous date was different, updating controller');
        print('New scannedMedicineExpirationDate: ${state.scannedMedicineExpirationDate}');

        if (state.scannedMedicineExpirationDate != null) {
          final formattedDate = _formatDate(state.scannedMedicineExpirationDate!);
          print('Setting controller text to: $formattedDate');
          _controller.text = formattedDate;
        } else {
          print('Clearing controller text');
          _controller.clear();
        }
        print('=== End ExpirationDateField Listener ===');
      },
      child: BlocBuilder<ServicesCubit, ServicesState>(
        buildWhen: (previous, current) =>
        previous.scannedMedicine != current.scannedMedicine ||
            previous.scannedMedicineExpirationDate != current.scannedMedicineExpirationDate,
        builder: (context, state) {
          final isEnabled = state.scannedMedicine != null;

          print('=== ExpirationDateField Builder ===');
          print('isEnabled: $isEnabled');
          print('scannedMedicineExpirationDate: ${state.scannedMedicineExpirationDate}');
          print('controller.text: ${_controller.text}');

          // Ensure the controller is updated if there's already a date
          if (state.scannedMedicineExpirationDate != null && _controller.text.isEmpty) {
            final formattedDate = _formatDate(state.scannedMedicineExpirationDate!);
            print('Builder: Setting controller text to: $formattedDate');
            _controller.text = formattedDate;
          }
          print('=== End ExpirationDateField Builder ===');

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
      print('Quantity set to 0 (empty)'); // Debug print
    } else {
      final quantity = int.tryParse(value);
      if (quantity != null && quantity >= 0 && quantity <= 9999) { // Add reasonable upper limit
        context.read<ServicesCubit>().setQuantity(quantity);
        print('Quantity set to: $quantity'); // Debug print
      } else {
        // Invalid input, revert to previous valid value
        final currentQuantity = state.scannedMedicineQuantity;
        if (currentQuantity > 0) {
          _controller.text = currentQuantity.toString();
        } else {
          _controller.clear();
        }
        print('Invalid quantity input: $value, reverted to: $currentQuantity'); // Debug print
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServicesCubit, ServicesState>(
      listenWhen: (previous, current) =>
      previous.scannedMedicineQuantity != current.scannedMedicineQuantity ||
          previous.scannedMedicine != current.scannedMedicine,
      listener: (context, state) {
        _isUpdatingFromState = true;

        print('QuantityField listener - Quantity: ${state.scannedMedicineQuantity}'); // Debug print

        if (state.scannedMedicine == null) {
          _controller.clear();
        } else if (state.scannedMedicineQuantity > 0) {
          _controller.text = state.scannedMedicineQuantity.toString();
        } else {
          // Only clear if quantity is explicitly 0
          _controller.clear();
        }

        _isUpdatingFromState = false;
      },
      child: BlocBuilder<ServicesCubit, ServicesState>(
        buildWhen: (previous, current) =>
        previous.scannedMedicine != current.scannedMedicine ||
            previous.scannedMedicineQuantity != current.scannedMedicineQuantity,
        builder: (context, state) {
          final isEnabled = state.scannedMedicine != null;

          // Ensure the controller shows the current quantity if not empty
          if (state.scannedMedicineQuantity > 0 && _controller.text != state.scannedMedicineQuantity.toString() && !_isUpdatingFromState) {
            _controller.text = state.scannedMedicineQuantity.toString();
          }

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
        previous.scannedMedicineExpirationDate != current.scannedMedicineExpirationDate ||
            previous.scannedMedicineQuantity != current.scannedMedicineQuantity ||
            previous.scannedMedicine != current.scannedMedicine ||
            previous.status != current.status ||
            previous.selectedPharmacyBoxId != current.selectedPharmacyBoxId,
        builder: (context, state) {
          // Use the convenience getter from the state
          final bool isEnabled = state.canAddScannedMedicine && !state.isLoading;

          // Debug info using the state getters
          print('=== Button State Debug ===');
          print('hasMedicineScanned: ${state.hasMedicineScanned} (${state.scannedMedicine?.name})');
          print('hasScannedExpirationDate: ${state.hasScannedExpirationDate} (${state.scannedMedicineExpirationDate})');
          print('hasScannedQuantity: ${state.hasScannedQuantity} (${state.scannedMedicineQuantity})');
          print('hasSelectedPharmacyBox: ${state.hasSelectedPharmacyBox} (${state.selectedPharmacyBoxId})');
          print('isNotLoading: ${!state.isLoading}');
          print('canAddScannedMedicine: ${state.canAddScannedMedicine}');
          print('Final isEnabled: $isEnabled');
          print('=========================');

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
                  ? () {
                print('Button pressed - calling addCurrentMedicineToCurrentBox');
                context.read<ServicesCubit>().addCurrentMedicineToCurrentBox();
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
              ),
              child: state.isLoading
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
                '${state.scannedMedicine?.name ?? "Le médicament"} a été ajouté à votre boîte de pharmacie avec ${state.scannedMedicineQuantity} unité(s).',
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