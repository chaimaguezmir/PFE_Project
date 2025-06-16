import 'package:flutter/material.dart';
import 'package:flutter_mobile/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return  const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Welcome Screen',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
