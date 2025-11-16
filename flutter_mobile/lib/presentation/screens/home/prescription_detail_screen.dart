// lib/presentation/screens/home/user_prescription_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/domain/entities/prescription/treatment_entity.dart';
import 'package:flutter_mobile/presentation/bloc/home/prescription_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/simple_custom_appbar.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/snackbar_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class PrescriptionDetailScreen extends StatefulWidget {
  const PrescriptionDetailScreen({super.key});

  @override
  State<PrescriptionDetailScreen> createState() => _PrescriptionDetailScreenState();
}

class _PrescriptionDetailScreenState extends State<PrescriptionDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch treatments when screen first loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshTreatments();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh treatments when returning to this screen
    _refreshTreatments();
  }

  void _refreshTreatments() {
    final selectedId = context.read<PrescriptionCubit>().state.selectedPrescriptionId;
    if (selectedId.isNotEmpty) {
      context.read<PrescriptionCubit>().fetchTreatments(selectedId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrescriptionCubit, PrescriptionState>(
      listener: (context, state) {
        if (state.treatmentErrorMessage != null) {
          SnackBarHelper.showError(context, state.treatmentErrorMessage!);
        }
        if (state.hasSuccess) {
          SnackBarHelper.showSuccess(context, state.successMessage!);
        }
      },
      child: Scaffold(
        appBar: DynamicPrescriptionAppBar(),
        body: const PrescriptionDetailBody(),
      ),
    );
  }
}

class DynamicPrescriptionAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(55.h);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrescriptionCubit, PrescriptionState>(
      buildWhen: (previous, current) =>
      previous.selectedPrescriptionId != current.selectedPrescriptionId ||
          previous.treatments != current.treatments,
      builder: (context, state) {
        // Get prescription name from treatments or use default
        String prescriptionName = 'Prescription';
        if (state.treatments.isNotEmpty) {
          prescriptionName = state.treatments.first.prescriptionName;
        }

        return SimpleCustomAppBar(
          title: prescriptionName,
          onBack: () => context.pop(),
        );
      },
    );
  }
}

class PrescriptionDetailBody extends StatelessWidget {
  const PrescriptionDetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrescriptionCubit, PrescriptionState>(
      builder: (context, state) {
        if (state.treatmentStatus == FormzSubmissionStatus.inProgress) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.treatmentStatus == FormzSubmissionStatus.failure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.sp,
                  color: Colors.red[400],
                ),
                SizedBox(height: 16.h),
                Text(
                  state.treatmentErrorMessage ?? 'Une erreur est survenue',
                  style: TextStyle(fontSize: 16.sp, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    final selectedId = state.selectedPrescriptionId;
                    if (selectedId.isNotEmpty) {
                      context.read<PrescriptionCubit>().fetchTreatments(selectedId);
                    }
                  },
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Add Treatment Header
            const AddTreatmentHeader(),

            // Medications List
            Expanded(child: MedicationsList(treatments: state.treatments)),

            // Validate Button
            const ValidateButton(),
            SizedBox(height: 20.h),
          ],
        );
      },
    );
  }
}

class AddTreatmentHeader extends StatelessWidget {
  const AddTreatmentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Ajouter Traitement',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          BlocBuilder<PrescriptionCubit, PrescriptionState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  // Navigate to treatment form with prescription ID
                  final prescriptionId = state.selectedPrescriptionId;
                  if (prescriptionId.isNotEmpty) {
                    context.pushNamed(
                      AppRouteName.treatmentForm,
                      extra: {'prescriptionId': prescriptionId},
                    );
                  }
                },
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: theme().colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MedicationsList extends StatelessWidget {
  const MedicationsList({super.key, required this.treatments});
  final List<TreatmentEntity> treatments;

  @override
  Widget build(BuildContext context) {
    if (treatments.isEmpty) {
      return Center(
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
              'Aucun traitement ajouté',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Ajoutez votre premier traitement',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () {
        final selectedId = context.read<PrescriptionCubit>().state.selectedPrescriptionId;
        if (selectedId.isNotEmpty) {
          return context.read<PrescriptionCubit>().fetchTreatments(selectedId);
        }
        return Future.value();
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        itemCount: treatments.length,
        itemBuilder: (context, index) {
          final treatment = treatments[index];
          return MedicationCard(treatment: treatment);
        },
      ),
    );
  }
}

class MedicationCard extends StatelessWidget {
  const MedicationCard({super.key, required this.treatment});

  final TreatmentEntity treatment;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to treatment form with treatment data for editing
        final prescriptionId = context.read<PrescriptionCubit>().state.selectedPrescriptionId;
        context.pushNamed(
          AppRouteName.treatmentForm,
          extra: {
            'prescriptionId': prescriptionId,
            'treatment': treatment,
            'isEdit': true,
          },
        );
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
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
        children: [
          // Medication Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  treatment.medicationName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  treatment.duration,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  treatment.instructions,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),

          // Progress Circle
          SizedBox(width: 16.w),
          GestureDetector(
            onTap: () => _showTreatmentDetails(context, treatment),
            child: Container(
              width: 50.w,
              height: 50.w,
              child: Stack(
                children: [
                  // Background Circle
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey[200]!,
                        width: 3.w,
                      ),
                    ),
                  ),
                  // Progress Circle
                  SizedBox(
                    width: 50.w,
                    height: 50.w,
                    child: CircularProgressIndicator(
                      value: treatment.progress / 100,
                      strokeWidth: 3.w,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        treatment.isCompleted
                            ? Colors.green
                            : theme().colorScheme.secondary,
                      ),
                    ),
                  ),
                  // Progress Text
                  Center(
                    child: Text(
                      '${treatment.progress}%',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: treatment.isCompleted
                            ? Colors.green
                            : theme().colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  void _showTreatmentDetails(BuildContext context, TreatmentEntity treatment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Détails du traitement',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Médicament', treatment.medicationName, isTitle: true),
              SizedBox(height: 12.h),
              _buildDetailRow('Dosage', treatment.dosage),
              SizedBox(height: 8.h),
              _buildDetailRow('Fréquence', treatment.frequency),
              SizedBox(height: 8.h),
              _buildDetailRow('Durée', '${treatment.durationDays} jours'),
              SizedBox(height: 8.h),
              _buildDetailRow('Progrès', '${treatment.progress}%'),
              SizedBox(height: 8.h),
              _buildDetailRow('Statut', treatment.isCompleted ? 'Terminé' : 'En cours'),
              SizedBox(height: 8.h),
              _buildDetailRow('Forme', treatment.dosageForm),
              SizedBox(height: 8.h),
              _buildDetailRow('Fabricant', treatment.manufacturerName),
              SizedBox(height: 8.h),
              _buildDetailRow('Boîte de pharmacie', treatment.myMedicine.pharmacyBoxName),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          if (!treatment.isCompleted)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showEditTreatment(context, treatment);
              },
              child: const Text('Modifier'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTitle = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isTitle ? 16.sp : 14.sp,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
              fontSize: isTitle ? 16.sp : 14.sp,
              color: isTitle ? Colors.black87 : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  void _showEditTreatment(BuildContext context, TreatmentEntity treatment) {
    final dosageController = TextEditingController(text: treatment.dosage);
    final frequencyController = TextEditingController(text: treatment.frequency);
    final durationController = TextEditingController(text: treatment.durationDays.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le traitement'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dosageController,
                decoration: const InputDecoration(
                  labelText: 'Dosage',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: frequencyController,
                decoration: const InputDecoration(
                  labelText: 'Fréquence',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(
                  labelText: 'Durée (jours)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PrescriptionCubit>().updateTreatment(
                id: treatment.id,
                dosage: dosageController.text.trim(),
                frequency: frequencyController.text.trim(),
                durationDays: int.tryParse(durationController.text) ?? treatment.durationDays,
              );
            },
            child: const Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }
}

class ValidateButton extends StatelessWidget {
  const ValidateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: () {
          // Navigate back to prescriptions list
          context.pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: theme().colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
          elevation: 2,
        ),
        child: Text(
          'Validé',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}