import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';

import 'package:flutter_mobile/injection_container.dart';
import 'package:flutter_mobile/presentation/bloc/profile/profile_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_app_bar.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          context.goNamed(AppRouteName.signIn);
        }
        if (state.status.isInProgress) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else {
          SnackBar(
            content: Text(
              state.errorMessage ?? state.successMessage ?? 'Action completed',
            ),
          );
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "Profile",
          username: "Walid Zaroui",
          email: "zarwi.walid@gmail.com",
          avatarPath: "lib/config/assets/images/default_avatar.jpg",
          showLeading: false,
        ),
        body: SafeArea(
          child: Center(
            child: ElevatedButton(
              onPressed: () => context.read<ProfileCubit>().logout(),
              child: const Text('Disconnect'),
            ),
          ),
        ),
      ),
    );
  }
}
