import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/domain/entities/services/my_medicine_entity.dart';
import 'package:flutter_mobile/domain/entities/services/PharmacyBoxEntity.dart';
import 'package:flutter_mobile/presentation/bloc/services/services_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/simple_custom_appbar.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/snackbar_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PharmacyBoxScreen extends StatelessWidget {
  const PharmacyBoxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch medicines when screen loads using the stored selectedPharmacyBoxId
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedId = context.read<ServicesCubit>().state.selectedPharmacyBoxId;
      if (selectedId.isNotEmpty) {
        context.read<ServicesCubit>().fetchMedicines(selectedId);
      }
    });

    return BlocListener<ServicesCubit, ServicesState>(
      listener: (context, state) {
        if (state.hasMedicineError) {
          SnackBarHelper.showError(context, state.medicineErrorMessage!);
        }
        if (state.hasMedicineSuccess) {
          SnackBarHelper.showSuccess(context, state.medicineSuccessMessage!);
        }
      },
      child: Scaffold(
        appBar: const DynamicPharmacyBoxAppBar(),
        body: const PharmacyBoxBody(),
      ),
    );
  }
}

class DynamicPharmacyBoxAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DynamicPharmacyBoxAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(55.h);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      buildWhen: (previous, current) =>
      previous.selectedPharmacyBoxName != current.selectedPharmacyBoxName,
      builder: (context, state) {
        return SimpleCustomAppBar(
          title: state.selectedPharmacyBoxName.isNotEmpty
              ? state.selectedPharmacyBoxName
              : 'Boîte',
          onBack: () => context.pop(),
        );
      },
    );
  }
}

class PharmacyBoxBody extends StatelessWidget {
  const PharmacyBoxBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      buildWhen: (previous, current) =>
      previous.medicineStatus != current.medicineStatus ||
          previous.filteredMedicines != current.filteredMedicines ||
          previous.medicineErrorMessage != current.medicineErrorMessage,
      builder: (context, state) {
        if (state.isMedicineLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.isMedicineFailure) {
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
                  state.medicineErrorMessage ?? 'Une erreur est survenue',
                  style: TextStyle(fontSize: 16.sp, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    // Retry with the stored selectedPharmacyBoxId
                    if (state.selectedPharmacyBoxId.isNotEmpty) {
                      context.read<ServicesCubit>().fetchMedicines(state.selectedPharmacyBoxId);
                    }
                  },
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.only(top: 35.h),
          child: Column(
            children: [
              MedicineSearchBar(allMedicines: state.allMedicines),
              SizedBox(height: 24.h),
              Expanded(child: MedicineList(medicines: state.filteredMedicines)),
              SizedBox(height: 16.h),
              const AddMedicineButton(),
            ],
          ),
        );
      },
    );
  }
}

class MedicineSearchBar extends StatelessWidget {
  const MedicineSearchBar({super.key, required this.allMedicines});
  final List<MyMedicineEntity> allMedicines;

  // Static controller that persists across rebuilds
  static final TextEditingController _globalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: _globalController,
        onChanged: (value) {
          context.read<ServicesCubit>().searchMedicines(value, allMedicines);
        },
        decoration: InputDecoration(
          hintText: 'Rechercher un médicament...',
          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600], size: 20.sp),
          suffixIcon: IconButton(
            onPressed: () {
              _globalController.clear();
              FocusScope.of(context).unfocus();
              context.read<ServicesCubit>().resetMedicineSearch(allMedicines);
            },
            icon: Icon(Icons.clear, color: Colors.grey[600], size: 20.sp),
          ),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.r),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.r),
            borderSide: BorderSide(
              color: theme().colorScheme.primary,
              width: 1.w,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.r),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.w),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }
}

class MedicineList extends StatelessWidget {
  const MedicineList({super.key, required this.medicines});
  final List<MyMedicineEntity> medicines;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        if (medicines.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  state.medicineSearchQuery.isNotEmpty
                      ? Icons.search_off
                      : Icons.medication_outlined,
                  size: 64.sp,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16.h),
                Text(
                  state.medicineSearchQuery.isNotEmpty
                      ? 'Aucun médicament trouvé pour "${state.medicineSearchQuery}"'
                      : 'Aucun médicament dans cette boîte',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (state.medicineSearchQuery.isEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(
                    'Ajoutez vos premiers médicaments',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ],
            ),
          );
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
          color: Colors.grey.shade50,
          child: RefreshIndicator(
            onRefresh: () {
              // Refresh using the stored selectedPharmacyBoxId
              if (state.selectedPharmacyBoxId.isNotEmpty) {
                return context.read<ServicesCubit>().fetchMedicines(state.selectedPharmacyBoxId);
              }
              return Future.value();
            },
            child: ListView.builder(
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final medicine = medicines[index];
                return MedicineCard(medicine: medicine);
              },
            ),
          ),
        );
      },
    );
  }
}

class MedicineCard extends StatelessWidget {
  const MedicineCard({super.key, required this.medicine});
  final MyMedicineEntity medicine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: medicine.customMedicine
                  ? const Color(0xFF2196F3).withOpacity(0.1)
                  : const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              medicine.customMedicine ? Icons.local_pharmacy : Icons.medication,
              color: medicine.customMedicine
                  ? const Color(0xFF2196F3)
                  : const Color(0xFF4CAF50),
              size: 24.sp,
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
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Reste ${medicine.remainingQuantity}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: medicine.remainingQuantity > 5
                        ? Colors.green[600]
                        : Colors.orange[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${medicine.dosageForm} - ${medicine.manufacturerName}',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => _showMedicineDetails(context, medicine),
                icon: Icon(
                  Icons.visibility_outlined,
                  size: 20.sp,
                  color: Colors.blue[600],
                ),
                tooltip: 'Voir détails',
              ),
              IconButton(
                onPressed: () => _showUpdateMedicine(context, medicine),
                icon: Icon(
                  Icons.edit_outlined,
                  size: 20.sp,
                  color: Colors.orange[600],
                ),
                tooltip: 'Modifier',
              ),
              IconButton(
                onPressed: () => _showDeleteConfirmation(context, medicine),
                icon: Icon(
                  Icons.delete_outline,
                  size: 20.sp,
                  color: Colors.red[600],
                ),
                tooltip: 'Supprimer',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMedicineDetails(BuildContext context, MyMedicineEntity medicine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Détails du médicament',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Nom', medicine.name, isTitle: true),
              SizedBox(height: 12.h),
              _buildDetailRow('Quantité restante', '${medicine.remainingQuantity}'),
              SizedBox(height: 8.h),
              _buildDetailRow('Forme', medicine.dosageForm),
              SizedBox(height: 8.h),
              _buildDetailRow('Fabricant', medicine.manufacturerName),
              SizedBox(height: 8.h),
              _buildDetailRow('Type', medicine.customMedicine ? "Personnalisé" : "Standard"),
              SizedBox(height: 8.h),
              _buildDetailRow('Historique d\'achats', '${medicine.purchaseHistoryCount} achats'),
              if (!medicine.customMedicine && medicine.medicine != null) ...[
                SizedBox(height: 8.h),
                _buildDetailRow('Code-barres', medicine.medicine!.barcode),
                SizedBox(height: 8.h),
                _buildDetailRow('Prescription requise',
                    medicine.medicine!.requiresPrescription ? 'Oui' : 'Non'),
              ],
              if (medicine.customMedicine) ...[
                SizedBox(height: 8.h),
                _buildDetailRow('Prescription requise',
                    medicine.customRequiresPrescription == true ? 'Oui' : 'Non'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
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

  void _showUpdateMedicine(BuildContext context, MyMedicineEntity medicine) {
    final TextEditingController nameController = TextEditingController(text: medicine.name);
    final TextEditingController quantityController = TextEditingController(
        text: medicine.remainingQuantity.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le médicament'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du médicament',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantité',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${nameController.text} mis à jour'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, MyMedicineEntity medicine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le médicament'),
        content: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 16.sp, color: Colors.black87),
            children: [
              const TextSpan(text: 'Êtes-vous sûr de vouloir supprimer '),
              TextSpan(
                text: medicine.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ' ?'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${medicine.name} supprimé'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              foregroundColor: Colors.red,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

class AddMedicineButton extends StatelessWidget {
  const AddMedicineButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      width: double.infinity,
      height: 56.h,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme().colorScheme.secondary, width: 2.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
          alignment: Alignment.center,
        ),
        onPressed: () {
          _showAddMedicineDialog(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                "Ajouter Médicament",
                style: TextStyle(
                  fontSize: 15.sp,
                  color: theme().colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.add_circle_outline,
              color: theme().colorScheme.secondary,
              size: 18.w,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMedicineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ... existing icon and title ...
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.medication_outlined,
                  size: 30.sp,
                  color: const Color(0xFF2196F3),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Ajouter un médicament\nmanuellement',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,

                  color: Colors.black87,
                  height: 1.3,
                ),
              ),SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ajout manuel - À implémenter')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: const Color(0xFF2196F3),
                        width: 1.5.w,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    // ... existing style ...
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ajouter Médicament',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: const Color(0xFF2196F3),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: const BoxDecoration(
                            color: Color(0xFF2196F3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.add, size: 16.sp, color: Colors.white),
                        ),
                      ],
                    ),
                ),
              ),

              // ... existing divider ...
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'Ou',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                'Scanner le code a barre\ndu médicament',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigate to barcode scanner
                      context.pushNamed(AppRouteName.barcodeScanner);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: const Color(0xFF2196F3),
                        width: 1.5.w,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    // ... existing style ...
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Scanner Code a barre',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: const Color(0xFF2196F3),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Icon(
                          Icons.qr_code_scanner,
                          size: 20.sp,
                          color: const Color(0xFF2196F3),
                        ),
                      ],
                    ),// ... existing scanner button content ...
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



}