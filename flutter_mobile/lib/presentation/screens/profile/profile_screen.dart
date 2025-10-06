// lib/presentation/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/injection_container.dart';
import 'package:flutter_mobile/presentation/bloc/profile/profile_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          // Remove the dialog and let the modal handle the loading state
        } else {
          if (state.errorMessage != null || state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      state.successMessage ??
                      'Action completed',
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
                          "Changer le mot de passe / Sécurité",
                        ],
                        onItemTap: (item) {
                          if (item == "Modifier mon profil") {
                            context.pushNamed(AppRouteName.editProfile);
                          } else {
                            _showSnackBar(context, item);
                          }
                        },
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
                          "Interactions médicamenteuses",
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
                          "Langue de l'application",
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
                          "Confidentialité & sécurité des données",
                        ],
                        onItemTap: (item) => _showSnackBar(context, item),
                      ),
                      const SizedBox(height: 16),
                      DisconnectButton(
                        onPressed: () => _showLogoutConfirmation(context),
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
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: context.read<ProfileCubit>(),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final isLoading = state.status.isInProgress;

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Handle indicator
                        Container(
                          width: 40.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Avatar/Icon
                        Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.logout,
                            size: 40.sp,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Title
                        Text(
                          'Déconnexion',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // Message
                        Text(
                          'êtes-vous sûr de vouloir vous\ndéconnecter',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 32.h),

                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: isLoading
                                    ? null
                                    : () => Navigator.pop(bottomSheetContext),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 1.5,
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Annuler',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Icon(
                                      Icons.close,
                                      color: Colors.grey.shade700,
                                      size: 20.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                  await context.read<ProfileCubit>().logout();
                                  if (context.mounted) {
                                    Navigator.pop(bottomSheetContext);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme().colorScheme.primary,
                                  disabledBackgroundColor:
                                  theme().colorScheme.primary.withOpacity(0.6),
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  elevation: 0,
                                ),
                                child: isLoading
                                    ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                    : Text(
                                  'Confirmer',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
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
  State<ExpandableProfileSection> createState() =>
      _ExpandableProfileSectionState();
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
                    child: Icon(widget.icon, size: 20, color: _getIconColor()),
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
          border: Border(top: BorderSide(color: Colors.grey[200]!, width: 0.5)),
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
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }
}

class DisconnectButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DisconnectButton({super.key, required this.onPressed});

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
                child: const Icon(Icons.logout, size: 20, color: Colors.red),
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
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
