import 'package:flutter/material.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/domain/entities/services/medicine.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/simple_custom_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PharmacyBoxScreen extends StatelessWidget {
  const PharmacyBoxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SimpleCustomAppBar(title: "Boite 1"),
      body: PharmacyBoxBody(),
    );
  }
}

class PharmacyBoxBody extends StatelessWidget {
  const PharmacyBoxBody({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Medicine> medicines = [
      const Medicine(
        name: 'Ibuprofen',
        description: 'Reste 1',
        type: 'Comprimé',
        iconPath: 'lib/config/assets/icons/medicine.png',
      ),
      const Medicine(
        name: 'Magnesium B6',
        description: 'Reste 2',
        type: 'Gélule',
        iconPath: 'lib/config/assets/icons/medicine.png',
      ),
      const Medicine(
        name: 'Actifed',
        description: 'Reste 13',
        type: 'Sirop',
        iconPath: 'lib/config/assets/icons/medicine.png',
      ),
      const Medicine(
        name: 'Zyrtec',
        description: 'Reste 15',
        type: 'Comprimé',
        iconPath: 'lib/config/assets/icons/medicine.png',
      ),
      const Medicine(
        name: 'Smecta',
        description: 'Reste 5',
        type: 'Sachet',
        iconPath: 'lib/config/assets/icons/medicine.png',
      ),
      const Medicine(
        name: 'Dafalgan',
        description: 'Reste 7',
        type: 'Comprimé',
        iconPath: 'lib/config/assets/icons/medicine.png',
      ),
      const Medicine(
        name: 'Efferalgan',
        description: 'Reste 8',
        type: 'Comprimé effervescent',
        iconPath: 'lib/config/assets/icons/medicine.png',
      ),
      const Medicine(
        name: 'Biodal 50000 UI',
        description: 'Reste 11',
        type: 'Capsule',
        iconPath: 'lib/config/assets/icons/medicine.png',
      ),
      const Medicine(
        name: 'Toplexil',
        description: 'Reste 18',
        type: 'Sirop',
        iconPath: 'lib/config/assets/icons/medicine.png',
      ),
      const Medicine(
        name: 'Doliprane',
        description: 'Reste 10',
        type: 'Comprimé',
        iconPath: 'lib/config/assets/icons/medicine.png',
      ),
    ];

    return Padding(
      padding: EdgeInsets.only(top: 35.h),
      child: Column(
        children: [
          const MedicineSearchBar(),
          SizedBox(height: 24.h),
          Expanded(child: MedicineList(medicines: medicines)),
          SizedBox(height: 16.h),
          const AddMedicineButton(),
        ],
      ),
    );
  }
}

class MedicineSearchBar extends StatelessWidget {
  const MedicineSearchBar({super.key});

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
        onChanged: (value) {
          // Handle search functionality
        },
        decoration: InputDecoration(
          hintText: 'Rechercher un médicament...',
          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600], size: 20.sp),
          suffixIcon: IconButton(
            onPressed: () {
              // Handle clear search
            },
            icon: Icon(Icons.clear, color: Colors.grey[600], size: 20.sp),
          ),
          //border reduis 20.r
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
  final List<Medicine> medicines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      color: Colors.grey.shade50,
      child: ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          final medicine = medicines[index];
          return MedicineCard(medicine: medicine);
        },
      ),
    );
  }
}

class MedicineCard extends StatelessWidget {
  const MedicineCard({super.key, required this.medicine});
  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.medication,
              color: const Color(0xFF4CAF50),
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
                  medicine.description,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // Handle view medicine details
                  _showMedicineDetails(context);
                },
                icon: Icon(
                  Icons.visibility_outlined,
                  size: 20.sp,
                  color: Colors.blue[600],
                ),
              ),
              IconButton(
                onPressed: () {
                  // Handle update medicine
                  _showUpdateMedicine(context);
                },
                icon: Icon(
                  Icons.edit_outlined,
                  size: 20.sp,
                  color: Colors.orange[600],
                ),
              ),
              IconButton(
                onPressed: () {
                  // Handle delete medicine
                  _showDeleteConfirmation(context);
                },
                icon: Icon(
                  Icons.delete_outline,
                  size: 20.sp,
                  color: Colors.red[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMedicineDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Détails du médicament'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nom: ${medicine.name}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text('Description: ${medicine.description}'),
            SizedBox(height: 8.h),
            Text('Type: ${medicine.type}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showUpdateMedicine(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier le médicament'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Nom du médicament',
                hintText: medicine.name,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: medicine.description,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle update logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${medicine.name} mis à jour')),
              );
            },
            child: Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer le médicament'),
        content: Text('Êtes-vous sûr de vouloir supprimer ${medicine.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          OutlinedButton(
            onPressed: () {
              // Handle delete logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${medicine.name} supprimé')),
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.red),
              foregroundColor: Colors.red,
            ),
            child: Text('Supprimer'),
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
      height: 50.h,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme().colorScheme.secondary, width: 2.w),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
        ),
        onPressed: () {
          // context.goNamed(AppRouteName.signUp);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Ajouter Médicament",
              style: TextStyle(
                fontSize: 16.sp,
                color: theme().colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 12.w),
            Icon(
              Icons.add_circle_outline,
              color: theme().colorScheme.secondary,
              size: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}
