import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/domain/entities/services/PharmacyBoxEntity.dart';
import 'package:flutter_mobile/presentation/bloc/services/services_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_app_bar.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/snackbar_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch data when screen loads

    return BlocListener<ServicesCubit, ServicesState>(
      listener: (context, state) {
        if (state.hasError) {
          SnackBarHelper.showError(context, state.errorMessage!);
        }
        if (state.hasSuccess) {
          SnackBarHelper.showSuccess(context, state.successMessage!);
        }
      },
      child: const ServicesScreenView(),
    );
  }
}

class ServicesScreenView extends StatelessWidget {
  const ServicesScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Services", showLeading: false),
      body: BlocBuilder<ServicesCubit, ServicesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage ?? 'Une erreur est survenue',
                    style: TextStyle(fontSize: 16.sp, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ServicesCubit>().fetchPharmacyBoxes();
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchBarWidget(allBoxes: state.allBoxes),
                SizedBox(height: 24.h),
                const FilteredBoxGrid(),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Search bar widget
// Replace your current SearchBarWidget with this one
class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key, required this.allBoxes});
  final List<PharmacyBoxEntity> allBoxes;

  // Static controller that persists across rebuilds
  static final TextEditingController _globalController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: _globalController,
        onChanged: (value) {
          context.read<ServicesCubit>().searchBoxes(value, allBoxes);
        },
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(Icons.clear, color: Colors.grey, size: 20.sp),
            onPressed: () {
              _globalController.clear();
              FocusScope.of(context).unfocus();
              context.read<ServicesCubit>().clearBoxSearch();
            },
          ),
          hintText: 'Votre recherche ici',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
          prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20.sp),
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

// Filtered box grid widget
class FilteredBoxGrid extends StatelessWidget {
  const FilteredBoxGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      buildWhen: (previous, current) =>
          previous.filteredBoxes != current.filteredBoxes ||
          previous.searchQuery != current.searchQuery,
      builder: (context, state) {
        if (state.filteredBoxes.isEmpty && state.searchQuery.isNotEmpty) {
          return const NoBoxesFoundWidget();
        }

        if (state.filteredBoxes.isEmpty) {
          return const Expanded(
            child: Center(child: Text('Aucune boîte disponible')),
          );
        }

        return Expanded(child: BoxGridWidget(boxes: state.filteredBoxes));
      },
    );
  }
}

// No boxes found widget
class NoBoxesFoundWidget extends StatelessWidget {
  const NoBoxesFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64.sp, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Text(
              'Aucune boite trouvée',
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Essayez une autre recherche',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}

// Grid widget for boxes
class BoxGridWidget extends StatelessWidget {
  const BoxGridWidget({super.key, required this.boxes});
  final List<PharmacyBoxEntity> boxes;

  static const List<Color> _colors = [
    Color(0xFF5FBEAA), // Teal
    Color(0xFFE8B4CB), // Pink
    Color(0xFF8FA7FF), // Blue
    Color(0xFFE5D5A3), // Beige
  ];

  static const List<IconData> _icons = [
    Icons.folder_outlined,
    Icons.favorite_outline,
    Icons.folder_outlined,
    Icons.favorite_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<ServicesCubit>().fetchPharmacyBoxes(),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 0.8,
        ),
        itemCount: boxes.length,
        itemBuilder: (context, index) {
          final box = boxes[index];
          final styleIndex = index % _colors.length;

          return BoxCardWidget(
            color: _colors[styleIndex],
            icon: _icons[styleIndex],
            title: box.groupName,
            count: box.medicationCount.toString(),
            pharmacyBox: box,
          );
        },
      ),
    );
  }
}

// Individual box card widget
class BoxCardWidget extends StatelessWidget {
  const BoxCardWidget({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.count,
    required this.pharmacyBox,
  });
  final Color color;
  final IconData icon;
  final String title;
  final String count;
  final PharmacyBoxEntity pharmacyBox;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Just select the pharmacy box ID
        context.read<ServicesCubit>().selectPharmacyBoxId(pharmacyBox.id);
        context.read<ServicesCubit>().selectPharmacyBoxName(
          pharmacyBox.groupName,
        );
        // Navigate without passing any data
        context.pushNamed(AppRouteName.pharmacyBox);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BoxCardHeaderWidget(icon: icon),
              const Spacer(),
              BoxCardContentWidget(title: title, count: count),
            ],
          ),
        ),
      ),
    );
  }
}

// Box card header (icon and arrow)
class BoxCardHeaderWidget extends StatelessWidget {
  const BoxCardHeaderWidget({super.key, required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: Colors.white, size: 20.sp),
        ),
        Icon(Icons.arrow_forward, color: Colors.white, size: 20.sp),
      ],
    );
  }
}

// Box card content (title and count)
class BoxCardContentWidget extends StatelessWidget {
  const BoxCardContentWidget({
    super.key,
    required this.title,
    required this.count,
  });
  final String title;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Text(
          count,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
