import 'package:flutter/material.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final isWelcomeScreen = navigationShell.currentIndex == 0;
    final currentLocation = GoRouterState.of(context).uri.toString();
    final isOnWelcomeRoute = currentLocation == '/home' || currentLocation == '/';

    return Scaffold(
      body: navigationShell,
      floatingActionButton: (isWelcomeScreen && isOnWelcomeRoute)
          ? SizedBox(
        width: 48.w,
        height: 48.h,
        child: FloatingActionButton(
          onPressed: () {
            context.pushNamed(AppRouteName.prescription);
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: const CircleBorder(),
          child: Icon(
            Icons.add,
            size: 28.sp,
            color: theme().colorScheme.onSecondary,
          ),
        ),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).colorScheme.onTertiary,
        selectedFontSize: 14.sp,
        unselectedFontSize: 14.sp,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/config/assets/icons/accueil.png',
              color: navigationShell.currentIndex == 0
                  ? theme().colorScheme.secondary
                  : theme().colorScheme.onTertiary,
              width: 24.sp,
              height: 24.sp,
            ),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/config/assets/icons/services.png',
              color: navigationShell.currentIndex == 1
                  ? theme().colorScheme.secondary
                  : theme().colorScheme.onTertiary,
              width: 24.sp,
              height: 24.sp,
            ),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/config/assets/icons/Group.png',
              color: navigationShell.currentIndex == 2
                  ? theme().colorScheme.secondary
                  : theme().colorScheme.onTertiary,
              width: 24.sp,
              height: 24.sp,
            ),
            label: 'Groupes',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/config/assets/icons/profile.png',
              color: navigationShell.currentIndex == 3
                  ? theme().colorScheme.secondary
                  : theme().colorScheme.onTertiary,
              width: 24.sp,
              height: 24.sp,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}