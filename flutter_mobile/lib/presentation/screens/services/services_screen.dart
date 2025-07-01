import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/presentation/bloc/services/services_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

// Data model for box items from database

// Main screen content widget
class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServicesCubit(),
      child: const ServicesScreenView(),
    );
  }
}

class ServicesScreenView extends StatelessWidget {
  const ServicesScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BoxData> boxes = [
      const BoxData(title: 'Boite 11', count: '12'),
      const BoxData(title: 'Boite 24', count: '8'),
      const BoxData(title: 'Boite 13', count: '15'),
      const BoxData(title: 'Boite 15', count: '12'),
      const BoxData(title: 'Boite 28', count: '8'),
      const BoxData(title: 'Boite 377', count: '15'),
      const BoxData(title: 'Boite 174', count: '12'),
      const BoxData(title: 'Boite 217', count: '8'),
      const BoxData(title: 'Boite 317', count: '15'),
      const BoxData(title: 'Boite 114', count: '12'),
      const BoxData(title: 'Boite 217', count: '8'),
      const BoxData(title: 'Boite 317141', count: '15'),
      const BoxData(title: 'Boite 14174', count: '12'),
      const BoxData(title: 'Boite 21417', count: '8'),
      const BoxData(title: 'Boite 311471', count: '15'),
      const BoxData(title: 'Boite 11417', count: '12'),
      const BoxData(title: 'Boite 21714', count: '8'),
      const BoxData(title: 'Boite 31417', count: '15'),
      const BoxData(title: 'Boite 114147', count: '12'),
      const BoxData(title: 'Boite 214555', count: '8'),
      const BoxData(title: 'Boite 44434', count: '15'),
      const BoxData(title: 'Boite 174', count: '12'),
      const BoxData(title: 'Boite 42', count: '8'),
      const BoxData(title: 'Boite 43', count: '15'),
      const BoxData(title: 'Boite 184', count: '12'),
      const BoxData(title: 'Boite 28', count: '8'),
      const BoxData(title: 'Boite 83', count: '15'),
      const BoxData(title: 'Boite 91', count: '12'),
      const BoxData(title: 'Boite 29', count: '8'),
      const BoxData(title: 'Boite 39', count: '15'),
    ];

    // Initialize the cubit with all boxes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServicesCubit>().initializeBoxes(boxes);
    });

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Services",
        username: "Walid Zaroui",
        email: "zarwi.walid@gmail.com",
        avatarPath: "lib/config/assets/images/default_avatar.jpg",
        showLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.only(left:16.w ,right:16.w ,top: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBarWidget(allBoxes: boxes),
            SizedBox(height: 24.h),
            const FilteredBoxGrid(),
          ],
        ),
      ),
    );
  }
}

// Search bar widget
class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key, required this.allBoxes});
  final List<BoxData> allBoxes;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        onChanged: (value) {
          context.read<ServicesCubit>().searchBoxes(value, allBoxes);
        },
        decoration: InputDecoration(
          hintText: 'Votre recherche ici',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
          prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20.sp),
          border: InputBorder.none,
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
      builder: (context, state) {
        if (state.filteredBoxes.isEmpty) {
          return const NoBoxesFoundWidget();
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
  final List<BoxData> boxes;

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
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 4 columns on large screens, 2 on small
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
          title: box.title,
          count: box.count,
        );
      },
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
  });
  final Color color;
  final IconData icon;
  final String title;
  final String count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show snackbar with box title
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Box sélectionnée: $title'),
            duration: const Duration(seconds: 2),
          ),

        );

        // Navigate to another page (replace 'boxDetailsScreen' with your route name)
        context.pushNamed(
          AppRouteName.pharmacyBox,
          extra: {'title': title, 'count': count},
        );
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
