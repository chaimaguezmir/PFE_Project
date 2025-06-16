import 'package:flutter/material.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/core/utils/shared_prefs_utils.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    await logout();
    context.goNamed(AppRouteName.signIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () => _handleLogout(context),
            child: const Text('Disconnect'),
          ),
        ),
      ),
    );
  }
}