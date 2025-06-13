import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/injection_container.dart';
import 'package:flutter_mobile/presentation/bloc/main_screen/main_screen_cubit.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MainScreenCubit>(),
      child: Scaffold(
        body: const SafeArea(child: Center(child: Text('Home Screen'))),

        bottomNavigationBar: BlocBuilder<MainScreenCubit, MainScreenState>(
          buildWhen: (previous, current) =>
              previous.selectedIndex != current.selectedIndex,
          builder: (context, state) {
            return BottomNavigationBar(
              currentIndex: state.selectedIndex,
              onTap: (index) {
                context.read<MainScreenCubit>().changeTab(index);
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: theme().colorScheme.secondary,
              unselectedItemColor: theme().colorScheme.onTertiary,
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
            );
          },
        ),
      ),
    );
  }
}
