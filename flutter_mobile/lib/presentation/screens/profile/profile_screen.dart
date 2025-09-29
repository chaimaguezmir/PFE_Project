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
          if (state.errorMessage != null || state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? state.successMessage ?? 'Action completed',
                ),
              ),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: const CustomAppBar(
          title: "Profile",
          username: "Walid Zaroui",
          email: "zarwi.walid@gmail.com",
          avatarPath: "lib/config/assets/images/default_avatar.jpg",
          showLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      ExpandableProfileSection(
                        title: "Mon compte",
                        icon: Icons.person_outline,
                        items: const [
                          "Mes informations personnelles",
                          "Modifier mon profil",
                          "Changer le mot de passe / Sécurité"
                        ],
                        onItemTap: (item) => _showSnackBar(context, item),
                      ),
                      const SizedBox(height: 16),
                      ExpandableProfileSection(
                        title: "Mes Médicaments",
                        icon: Icons.medical_services_outlined,
                        items: const [
                          "Mes médicaments enregistrés",
                          "Mes rappels",
                          "Mes rendez-vous médicaux",
                          "Ordonnances et renouvellements",
                          "Interactions médicamenteuses"
                        ],
                        onItemTap: (item) => _showSnackBar(context, item),
                      ),
                      const SizedBox(height: 16),
                      ExpandableProfileSection(
                        title: "Préférences",
                        icon: Icons.settings_outlined,
                        items: const [
                          "Paramètres de notifications",
                          "Mode sombre / clair",
                          "Langue de l'application"
                        ],
                        onItemTap: (item) => _showSnackBar(context, item),
                      ),
                      const SizedBox(height: 16),
                      ExpandableProfileSection(
                        title: "Support & Légal",
                        icon: Icons.help_outline,
                        items: const [
                          "Aide & FAQ",
                          "Contact support / assistance",
                          "Confidentialité & sécurité des données"
                        ],
                        onItemTap: (item) => _showSnackBar(context, item),
                      ),
                      const SizedBox(height: 16),
                      DisconnectButton(
                        onPressed: () => context.read<ProfileCubit>().logout(),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class ExpandableProfileSection extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<String> items;
  final Function(String) onItemTap;

  const ExpandableProfileSection({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
    required this.onItemTap,
  });

  @override
  State<ExpandableProfileSection> createState() => _ExpandableProfileSectionState();
}

class _ExpandableProfileSectionState extends State<ExpandableProfileSection>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _iconRotation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getIconColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 20,
                      color: _getIconColor(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  RotationTransition(
                    turns: _iconRotation,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey[400],
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            Container(
              width: double.infinity,
              height: 0.5,
              color: Colors.grey[200],
            ),
            ...widget.items.map(
                  (item) => ProfileSubMenuItem(
                title: item,
                onTap: () => widget.onItemTap(item),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getIconColor() {
    switch (widget.title) {
      case "Mon compte":
        return Colors.blue;
      case "Mes Médicaments":
        return Colors.green;
      case "Préférences":
        return Colors.orange;
      case "Support & Légal":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

class ProfileSubMenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ProfileSubMenuItem({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey[200]!,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 48),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class DisconnectButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DisconnectButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.logout,
                  size: 20,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Déconnexion",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}