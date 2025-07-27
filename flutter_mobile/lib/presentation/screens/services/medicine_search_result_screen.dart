import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/domain/entities/services/medicine_entity.dart';
import 'package:flutter_mobile/presentation/bloc/services/services_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/simple_custom_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MedicineSearchResultScreen extends StatelessWidget {
  const MedicineSearchResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const SimpleCustomAppBar(title: "Résultat de Recherche"),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ServicesState state) {
    if (state.isScanLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Recherche en cours...'),
          ],
        ),
      );
    }

    if (state.isScanFailure) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
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
                'Médicament non trouvé',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[600],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                state.scanErrorMessage ?? 'Aucun médicament trouvé pour ce code-barres',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<ServicesCubit>().clearScannedMedicine();
                        context.pushReplacementNamed(AppRouteName.barcodeScanner);
                      },
                      child: const Text('Scanner à nouveau'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Retour'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (state.isScanSuccess && state.scannedMedicine != null) {
      return MedicineDetailsCard(
        medicine: state.scannedMedicine!,
        barcode: state.scannedBarcode,
      );
    }

    return const Center(child: Text('Aucune donnée disponible'));
  }
}

class MedicineDetailsCard extends StatelessWidget {
  const MedicineDetailsCard({
    super.key,
    required this.medicine,
    required this.barcode,
  });

  final MedicineEntity medicine;
  final String barcode;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Medicine Info Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.grey[300]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.medication,
                        color: const Color(0xFF4CAF50),
                        size: 32.sp,
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
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            medicine.manufacturer,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                _buildDetailRow('Forme', medicine.dosageForm),
                _buildDetailRow('Fabricant', medicine.manufacturer),
                _buildDetailRow('Prescription requise',
                    medicine.requiresPrescription ? 'Oui' : 'Non'),
                _buildDetailRow('Code-barres', barcode),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // Add to Pharmacy Box Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: theme().colorScheme.secondary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: theme().colorScheme.secondary.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ajouter à votre pharmacie',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: theme().colorScheme.secondary,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Voulez-vous ajouter ce médicament à votre boîte de pharmacie actuelle ?',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<ServicesCubit>().clearScannedMedicine();
                          context.pushReplacementNamed(AppRouteName.barcodeScanner);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: theme().colorScheme.secondary),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: const Text('Scanner un autre'),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement add medicine to pharmacy box
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${medicine.name} ajouté - À implémenter'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          context.pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme().colorScheme.secondary,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: const Text('Ajouter', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}