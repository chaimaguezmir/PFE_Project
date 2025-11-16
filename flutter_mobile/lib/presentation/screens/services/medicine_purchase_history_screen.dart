import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/domain/entities/services/my_medicine_entity.dart';
import 'package:flutter_mobile/domain/entities/services/purchase_history_entity.dart';
import 'package:flutter_mobile/presentation/bloc/services/services_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/simple_custom_appbar.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/snackbar_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MedicinePurchaseHistoryScreen extends StatelessWidget {
  const MedicinePurchaseHistoryScreen({
    super.key,
    required this.medicine,
  });

  final MyMedicineEntity medicine;

  @override
  Widget build(BuildContext context) {
    // Fetch purchase history when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServicesCubit>().fetchPurchaseHistory(medicine.id);
    });

    return BlocListener<ServicesCubit, ServicesState>(
      listener: (context, state) {
        if (state.hasPurchaseHistoryError) {
          SnackBarHelper.showError(context, state.purchaseHistoryErrorMessage!);
        }
      },
      child: Scaffold(
        appBar: SimpleCustomAppBar(
          title: 'Historique d\'achats',
          onBack: () => context.pop(),
        ),
        body: Column(
          children: [
            MedicineInfoCard(medicine: medicine),
            Expanded(
              child: PurchaseHistoryList(medicine: medicine),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicineInfoCard extends StatelessWidget {
  const MedicineInfoCard({super.key, required this.medicine});
  final MyMedicineEntity medicine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
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
              color: medicine.customMedicine
                  ? const Color(0xFF2196F3).withValues(alpha: 0.1)
                  : const Color(0xFF4CAF50).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              medicine.customMedicine ? Icons.local_pharmacy : Icons.medication,
              color: medicine.customMedicine
                  ? const Color(0xFF2196F3)
                  : const Color(0xFF4CAF50),
              size: 28.sp,
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
                  '${medicine.dosageForm} - ${medicine.manufacturerName}',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.inventory_2_outlined,
                        size: 16.sp, color: Colors.orange[600]),
                    SizedBox(width: 4.w),
                    Text(
                      'Reste: ${medicine.remainingQuantity}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: medicine.remainingQuantity > 5
                            ? Colors.green[600]
                            : Colors.orange[600],
                        fontWeight: FontWeight.w500,
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
}

class PurchaseHistoryList extends StatelessWidget {
  const PurchaseHistoryList({super.key, required this.medicine});
  final MyMedicineEntity medicine;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      buildWhen: (previous, current) =>
          previous.purchaseHistoryStatus != current.purchaseHistoryStatus ||
          previous.purchaseHistoryList != current.purchaseHistoryList,
      builder: (context, state) {
        if (state.isPurchaseHistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.isPurchaseHistoryFailure) {
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
                  state.purchaseHistoryErrorMessage ?? 'Une erreur est survenue',
                  style: TextStyle(fontSize: 16.sp, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    context.read<ServicesCubit>().fetchPurchaseHistory(medicine.id);
                  },
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        if (state.purchaseHistoryList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 64.sp,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16.h),
                Text(
                  'Aucun historique d\'achat',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Les achats de ce médicament\napparaîtront ici',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Container(
          color: Colors.grey.shade50,
          child: RefreshIndicator(
            onRefresh: () =>
                context.read<ServicesCubit>().fetchPurchaseHistory(medicine.id),
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: state.purchaseHistoryList.length,
              itemBuilder: (context, index) {
                final purchase = state.purchaseHistoryList[index];
                return PurchaseHistoryCard(
                  purchase: purchase,
                  isLatest: index == 0,
                  medicine: medicine,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class PurchaseHistoryCard extends StatelessWidget {
  const PurchaseHistoryCard({
    super.key,
    required this.purchase,
    required this.isLatest,
    required this.medicine,
  });

  final PurchaseHistoryEntity purchase;
  final bool isLatest;
  final MyMedicineEntity medicine;

  @override
  Widget build(BuildContext context) {
    final isExpired = purchase.expiryDate.isBefore(DateTime.now());
    final daysUntilExpiry = purchase.expiryDate.difference(DateTime.now()).inDays;
    final isExpiringSoon = daysUntilExpiry <= 30 && daysUntilExpiry > 0;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isLatest
              ? theme().colorScheme.primary.withValues(alpha: 0.5)
              : Colors.grey[300]!,
          width: isLatest ? 2.w : 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: const Color(0xFF4CAF50),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Quantité: ${purchase.quantityPurchased}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (isLatest)
                          Container(
                            margin: EdgeInsets.only(left: 8.w),
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: theme().colorScheme.primary,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              'Récent',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (purchase.createdAt != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        'Acheté le ${DateFormat('dd/MM/yyyy').format(purchase.createdAt!)}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _showEditModal(context),
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 20.sp,
                      color: Colors.orange[600],
                    ),
                    tooltip: 'Modifier',
                    padding: EdgeInsets.all(4.w),
                    constraints: BoxConstraints(
                      minWidth: 32.w,
                      minHeight: 32.h,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  IconButton(
                    onPressed: () => _showDeleteDialog(context),
                    icon: Icon(
                      Icons.delete_outline,
                      size: 20.sp,
                      color: Colors.red[600],
                    ),
                    tooltip: 'Supprimer',
                    padding: EdgeInsets.all(4.w),
                    constraints: BoxConstraints(
                      minWidth: 32.w,
                      minHeight: 32.h,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(height: 1.h, color: Colors.grey[300]),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16.sp,
                color: isExpired
                    ? Colors.red[600]
                    : isExpiringSoon
                        ? Colors.orange[600]
                        : Colors.grey[600],
              ),
              SizedBox(width: 8.w),
              Text(
                'Expire le: ${DateFormat('dd/MM/yyyy').format(purchase.expiryDate)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          if (isExpired)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber_rounded,
                      size: 16.sp, color: Colors.red[600]),
                  SizedBox(width: 6.w),
                  Text(
                    'Expiré',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.red[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else if (isExpiringSoon)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline,
                      size: 16.sp, color: Colors.orange[600]),
                  SizedBox(width: 6.w),
                  Text(
                    'Expire dans $daysUntilExpiry jours',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 16.sp, color: Colors.green[600]),
                  SizedBox(width: 6.w),
                  Text(
                    'Valide',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showEditModal(BuildContext context) {
    final TextEditingController quantityController =
        TextEditingController(text: purchase.quantityPurchased.toString());
    DateTime selectedDate = purchase.expiryDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                top: 24.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Modifier l\'historique',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(modalContext),
                        icon: const Icon(Icons.close),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Quantité achetée',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Entrez la quantité',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      prefixIcon: const Icon(Icons.inventory_2_outlined),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Date d\'expiration',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: modalContext,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 3650)),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.grey[600],
                                size: 20.sp,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                DateFormat('dd/MM/yyyy').format(selectedDate),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.sp,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        final quantity =
                            int.tryParse(quantityController.text) ?? 0;
                        if (quantity <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Veuillez entrer une quantité valide'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        Navigator.pop(modalContext);
                        context.read<ServicesCubit>().updatePurchaseHistory(
                              purchaseHistoryId: purchase.id,
                              myMedicineId: medicine.id,
                              quantityPurchased: quantity,
                              expiryDate: selectedDate,
                            );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Historique mis à jour avec succès'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme().colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Enregistrer',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red[600],
              size: 28.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              'Confirmer la suppression',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Êtes-vous sûr de vouloir supprimer cet historique d\'achat ?',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              'Cette action est irréversible.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Annuler',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ServicesCubit>().deletePurchaseHistory(
                    purchaseHistoryId: purchase.id,
                    myMedicineId: medicine.id,
                  );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Historique supprimé avec succès'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Supprimer',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
