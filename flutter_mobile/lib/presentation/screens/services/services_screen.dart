import 'package:flutter/material.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data - in a real app, this would come from a model or API
    final List<BoxItem> boxItems = List.generate(
      100,
          (index) => BoxItem(
        id: index + 1,
        title: 'Boite ${index + 1}',
        count: 12 + index,
        icon: Icons.monitor_heart_rounded,
        color: Colors.green,
      ),
    );

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Groupes",
        username: "Walid Zaroui",
        email: "zarwi.walid@gmail.com",
        avatarPath: "lib/config/assets/images/default_avatar.jpg",
        showLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(context),
              SizedBox(height: 40.h),
              _buildBoxList(boxItems),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'Vos Boites',
      style: TextStyle(
        color: theme().colorScheme.onPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 45.sp,
      ),
    );
  }

  Widget _buildBoxList(List<BoxItem> items) {
    return SizedBox(
      height: 450.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(
              right: index < items.length - 1 ? 30.w : 0, // No margin on last item
              bottom: 20.h, // Bottom margin for all items
            ),
            child: BoxCard(item: items[index]),
          );
        },
      ),
    );
  }
}

class BoxCard extends StatelessWidget {

  const BoxCard({
    super.key,
    required this.item,
  });
  final BoxItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      margin: EdgeInsets.symmetric(
        horizontal: 10.w, // Horizontal margin around the card
        vertical: 15.h,   // Vertical margin around the card
      ),
      child: ElevatedButton(
        onPressed: () => _onBoxTapped(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: item.color.shade200,
          elevation:0,
          shadowColor: item.color.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.all(30.w),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: item.color.shade300,
          ),
          child: Icon(
            item.icon,
            size: 60.w,
            color: Colors.white,
          ),
        ),
        Icon(
          Icons.arrow_right_alt_outlined,
          size: 60.w,
          color: Colors.black54,
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          '${item.count}',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  void _onBoxTapped(BuildContext context) {
    // Handle box tap - navigate to detail screen or show dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.title} tapped!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

// Data model for box items
class BoxItem {

  const BoxItem({
    required this.id,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });
  final int id;
  final String title;
  final int count;
  final IconData icon;
  final MaterialColor color;
}

