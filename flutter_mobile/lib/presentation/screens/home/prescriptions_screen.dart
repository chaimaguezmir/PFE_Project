// lib/presentation/screens/home/user_prescriptions_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/domain/entities/prescription/prescription_entity.dart';
import 'package:flutter_mobile/presentation/bloc/home/prescription_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_app_bar.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/snackbar_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PrescriptionsScreen extends StatelessWidget {
  const PrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch prescriptions when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrescriptionCubit>().fetchPrescriptions();
    });

    return BlocListener<PrescriptionCubit, PrescriptionState>(
      listener: (context, state) {
        if (state.hasError) {
          SnackBarHelper.showError(context, state.errorMessage!);
        }
        if (state.hasSuccess) {
          SnackBarHelper.showSuccess(context, state.successMessage!);
        }
      },
      child: const Scaffold(
        appBar: CustomAppBar(title: "Vos Prescriptions", showLeading: true),
        body: PrescriptionsBody(),
      ),
    );
  }
}

class PrescriptionsBody extends StatelessWidget {
  const PrescriptionsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrescriptionCubit, PrescriptionState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.isFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64.sp, color: Colors.red[400]),
                SizedBox(height: 16.h),
                Text(
                  state.errorMessage ?? 'Une erreur est survenue',
                  style: TextStyle(fontSize: 16.sp, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    context.read<PrescriptionCubit>().fetchPrescriptions();
                  },
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              Text(
                'Vos Prescriptions',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 24.h),

              // Prescription List - FIXED: Convert models to entities properly
              Expanded(
                child: PrescriptionsList(prescriptions: state.allPrescriptions),
              ),

              SizedBox(height: 20.h),

              // Add Prescription Button
              const AddPrescriptionButton(),
            ],
          ),
        );
      },
    );
  }
}

class PrescriptionsList extends StatelessWidget {
  const PrescriptionsList({super.key, required this.prescriptions});
  // FIXED: Accept PrescriptionEntity list directly
  final List<PrescriptionEntity> prescriptions;

  @override
  Widget build(BuildContext context) {
    if (prescriptions.isEmpty) {
      return const Center(child: Text('Aucune prescription disponible'));
    }

    return RefreshIndicator(
      onRefresh: () => context.read<PrescriptionCubit>().refreshPrescriptions(),
      child: ListView.builder(
        itemCount: prescriptions.length,
        itemBuilder: (context, index) {
          final prescription = prescriptions[index];
          return PrescriptionCard(prescription: prescription);
        },
      ),
    );
  }
}

class PrescriptionCard extends StatelessWidget {
  const PrescriptionCard({super.key, required this.prescription});

  final PrescriptionEntity prescription;

  // Simple color mapping based on your original design
  Color _getPrescriptionColor(int index) {
    const colors = [Color(0xFF5FBEAA), Color(0xFFE8B4CB), Color(0xFF8FA7FF)];
    return colors[index % colors.length];
  }

  // Simple icon mapping
  IconData _getPrescriptionIcon(int index) {
    const icons = [
      Icons.medical_services_outlined,
      Icons.hearing_outlined,
      Icons.local_hospital_outlined,
    ];
    return icons[index % icons.length];
  }

  @override
  Widget build(BuildContext context) {
    // Use hash code to get consistent color/icon for same prescription
    final colorIndex = prescription.id.hashCode.abs() % 3;
    final color = _getPrescriptionColor(colorIndex);
    final icon = _getPrescriptionIcon(colorIndex);

    return GestureDetector(
      onTap: () {
        // Store prescription ID in state and navigate
        context.read<PrescriptionCubit>().selectPrescriptionAndFetchTreatments(
          prescription.id,
        );
        context.pushNamed(AppRouteName.prescriptionDetail);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),

            SizedBox(width: 16.w),

            // Prescription Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prescription.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    prescription.duration,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Three-dot menu icon
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.grey[600], size: 20.sp),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              onSelected: (value) {
                if (value == 'delete') {
                  _handleDelete(context);
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18.sp, color: Colors.red),
                      SizedBox(width: 12.w),
                      Text('Supprimer', style: TextStyle(fontSize: 14.sp)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleDelete(BuildContext context) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Supprimer la prescription',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer "${prescription.name}" ?\n\nCette action est irréversible.',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Annuler',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Close dialog
              Navigator.pop(dialogContext);

              // Delete prescription
              context.read<PrescriptionCubit>().deletePrescription(prescription.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Supprimer',
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class AddPrescriptionButton extends StatelessWidget {
  const AddPrescriptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        border: Border.all(color: theme().colorScheme.secondary, width: 2.sp),
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: ElevatedButton(
        onPressed: () {
          // Navigate to prescription form
          context.pushNamed(AppRouteName.prescriptionForm);
        },
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
              'Ajouter Prescription',
              style: TextStyle(
                color: theme().colorScheme.secondary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: theme().colorScheme.secondary,
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
