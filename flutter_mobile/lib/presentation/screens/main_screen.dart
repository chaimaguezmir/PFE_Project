import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/core/network/network_controller.dart';
import 'package:flutter_mobile/injection_container.dart';
import 'package:flutter_mobile/presentation/bloc/group/group_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/main_screen/main_screen_cubit.dart';
import 'package:flutter_mobile/presentation/screens/group/group_screen.dart';
import 'package:flutter_mobile/presentation/screens/home/welcome_screen.dart';
import 'package:flutter_mobile/presentation/screens/profile/profile_screen.dart';
import 'package:flutter_mobile/presentation/screens/services/services_screen.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_app_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const WelcomeScreen(),
      const ServicesScreen(),
      const GroupScreen(),
      const ProfileScreen(),
    ];
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<MainScreenCubit>()),
        BlocProvider(create: (context) => sl<GroupCubit>()),

      ],
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Profile",
          username: "Walid Zaroui",
          email: "zarwi.walid@gmail.com",
          avatarPath: "lib/config/assets/images/default_avatar.jpg",
          showLeading: false,
          onBack: () {}, // 👈 hide back button
        ),
        backgroundColor: theme().colorScheme.onSecondary,
        body: SafeArea(
          child: BlocBuilder<MainScreenCubit, MainScreenState>(
            buildWhen: (previous, current) =>
                previous.selectedIndex != current.selectedIndex,
            builder: (context, state) {
              return screens[state.selectedIndex];
            },
          ),
        ),

        bottomNavigationBar: const _BottomNavBar(),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenCubit, MainScreenState>(
      buildWhen: (previous, current) =>
          previous.selectedIndex != current.selectedIndex,
      builder: (context, state) {
        return Theme(
          data: Theme.of(context).copyWith(
            splashColor: theme().colorScheme.onSecondary,
            highlightColor: theme().colorScheme.tertiary,
          ),

          child: BottomNavigationBar(
            currentIndex: state.selectedIndex,
            onTap: (index) {
              context.read<MainScreenCubit>().changeTab(index);
            },

            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'lib/config/assets/icons/accueil.png',
                  color: state.selectedIndex == 0
                      ? theme().colorScheme.secondary
                      : theme().colorScheme.onTertiary,
                ),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'lib/config/assets/icons/services.png',
                  color: state.selectedIndex == 1
                      ? theme().colorScheme.secondary
                      : theme().colorScheme.onTertiary,
                ),
                label: 'Services',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'lib/config/assets/icons/groupes.png',
                  color: state.selectedIndex == 2
                      ? theme().colorScheme.secondary
                      : theme().colorScheme.onTertiary,
                ),
                label: 'Groupes',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'lib/config/assets/icons/profile.png',
                  color: state.selectedIndex == 3
                      ? theme().colorScheme.secondary
                      : theme().colorScheme.onTertiary,
                ),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
