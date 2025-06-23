import 'package:flutter/material.dart';

class Destination {
  Destination({required this.label, required this.iconPath});
  final String label;
  final String iconPath;
}

final destinations = [
  Destination(
    label: 'Accueil',
    iconPath: 'lib/config/assets/icons/accueil.png',
  ),
  Destination(
    label: 'Services',
    iconPath: 'lib/config/assets/icons/services.png',
  ),
  Destination(
    label: 'Groupe',
    iconPath: 'lib/config/assets/icons/groupes.png',
  ),
  Destination(
    label: 'Profile',
    iconPath: 'lib/config/assets/icons/profile.png',
  ),
];