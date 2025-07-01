import 'package:flutter/material.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/simple_custom_appbar.dart';

class PharmacyBoxScreen extends StatelessWidget {
  const PharmacyBoxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SimpleCustomAppBar(title: "Your Title"),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bienvenue dans la section Pharmacie',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Ici, vous pouvez trouver des informations sur les médicaments et les pharmacies.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
