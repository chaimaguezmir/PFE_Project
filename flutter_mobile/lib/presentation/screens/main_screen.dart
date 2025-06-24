import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/core/utils/destination.dart';
import 'package:flutter_mobile/injection_container.dart';
import 'package:flutter_mobile/presentation/bloc/group/group_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/main_screen/main_screen_cubit.dart';
import 'package:flutter_mobile/presentation/screens/group/group_screen.dart';
import 'package:flutter_mobile/presentation/screens/home/welcome_screen.dart';
import 'package:flutter_mobile/presentation/screens/profile/profile_screen.dart';
import 'package:flutter_mobile/presentation/screens/services/services_screen.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key, required this.navigationShell})
    : super(key: key ?? const ValueKey<String>('MainScreen'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: navigationShell,
    bottomNavigationBar: Theme(
      data: Theme.of(context).copyWith(
        splashColor: theme().colorScheme.onSecondary,
        highlightColor: theme().colorScheme.tertiary,
      ),
      child: BottomNavigationBar(
        items: List.generate(destinations.length, (index) {
          final isSelected = navigationShell.currentIndex == index;
          return BottomNavigationBarItem(
            icon: Image.asset(
              destinations[index].iconPath,
              color: isSelected ? theme().colorScheme.secondary : Colors.grey,
            ),
            label: destinations[index].label,
          );
        }),
        currentIndex: navigationShell.currentIndex,
        selectedItemColor: theme().colorScheme.secondary,
        onTap: navigationShell.goBranch,
      ),
    ),
  );
}
