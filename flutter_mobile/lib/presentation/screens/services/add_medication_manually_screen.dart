import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/domain/entities/services/medicine_entity.dart';
import 'package:flutter_mobile/presentation/bloc/services/services_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/simple_custom_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';


// Replace your existing AddMedicationManuallyScreen with this implementation

class AddMedicationManuallyScreen extends StatelessWidget {
  const AddMedicationManuallyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleCustomAppBar(
        title: 'Ajouter Un Médicament',
        onBack: () {
          context.read<ServicesCubit>().clearSearch();
          context.pop();
        },
      ),
      body: const MedicineSearchBody(),
    );
  }
}

class MedicineSearchBody extends StatelessWidget {
  const MedicineSearchBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServicesCubit, ServicesState>(
      listener: (context, state) {
        // REMOVED: Success dialog listener - this will be handled by MedicationTrackerScreen
        // The manual medicine flow now goes: Search → Select → MedicationTracker → Success Dialog

        // Only handle errors here
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
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Rechercher un médicament',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Tapez le nom du médicament pour le rechercher',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24.h),

            // Search Field
            const MedicineSearchField(),
            SizedBox(height: 16.h),

            // Search Results
            const Expanded(child: SearchResultsSection()),
          ],
        ),
      ),
    );
  }

}


class MedicineSearchField extends StatefulWidget {
  const MedicineSearchField({super.key});

  @override
  State<MedicineSearchField> createState() => _MedicineSearchFieldState();
}

class _MedicineSearchFieldState extends State<MedicineSearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      buildWhen: (previous, current) =>
      previous.searchQuery != current.searchQuery ||
          previous.isSearching != current.isSearching,
      builder: (context, state) {
        return TextField(
          controller: _controller,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black87,
          ),
          onChanged: (value) {
            context.read<ServicesCubit>().searchMedicinesByName(value);
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: theme().colorScheme.onTertiary,
            ),
            suffixIcon: state.isSearching
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
                : _controller.text.isNotEmpty
                ? IconButton(
              onPressed: () {
                _controller.clear();
                context.read<ServicesCubit>().clearSearch();
              },
              icon: Icon(
                Icons.clear,
                color: theme().colorScheme.onTertiary,
              ),
            )
                : null,
            labelText: 'Rechercher un médicament',
            hintText: 'Tapez le nom du médicament...',
            labelStyle: TextStyle(
              fontSize: 16.sp,
              color: theme().colorScheme.onTertiary,
            ),
            floatingLabelStyle: TextStyle(color: theme().colorScheme.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
              borderSide: BorderSide(color: theme().colorScheme.tertiary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: theme().colorScheme.tertiary,
                width: 1.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
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
    );
  }
}

class SearchResultsSection extends StatelessWidget {
  const SearchResultsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      buildWhen: (previous, current) =>
      previous.searchResults != current.searchResults ||
          previous.searchStatus != current.searchStatus ||
          previous.hasSearchError != current.hasSearchError,
      builder: (context, state) {
        if (state.hasSearchError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
                SizedBox(height: 16.h),
                Text(
                  state.searchErrorMessage!,
                  style: TextStyle(fontSize: 16.sp, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (state.searchQuery.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 64.sp,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16.h),
                Text(
                  'Commencez à taper pour rechercher des médicaments',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (state.isSearching) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!state.hasSearchResults) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64.sp,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16.h),
                Text(
                  'Aucun médicament trouvé pour "${state.searchQuery}"',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Résultats de recherche (${state.searchResults.length})',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: ListView.builder(
                itemCount: state.searchResults.length,
                itemBuilder: (context, index) {
                  final medicine = state.searchResults[index];
                  return MedicineResultCard(medicine: medicine);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class MedicineResultCard extends StatelessWidget {
  const MedicineResultCard({super.key, required this.medicine});
  final MedicineEntity medicine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: () {
          // Set the medicine as scanned medicine (same as barcode scanner)
          context.read<ServicesCubit>().emit(
            context.read<ServicesCubit>().state.copyWith(
              scannedMedicine: medicine,
              scanStatus: FormzSubmissionStatus.success,
              scanErrorMessage: null,
              scannedBarcode: medicine.barcode,
            ),
          );
          // Navigate to MedicationTrackerScreen (same as barcode scanner)
          context.pushNamed(AppRouteName.medicationTracker);
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
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
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.medication,
                  color: Colors.blue,
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
                      '${medicine.dosageForm} - ${medicine.manufacturer}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (medicine.requiresPrescription)
                      Container(
                        margin: EdgeInsets.only(top: 4.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'Sur ordonnance',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.orange[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}