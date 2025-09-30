import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/presentation/bloc/profile/edit_profile_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/snackbar_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          SnackBarHelper.showError(context, state.errorMessage!);
          context.read<EditProfileCubit>().clearMessages();
        }
        if (state.successMessage != null) {
          SnackBarHelper.showSuccess(context, state.successMessage!);
          context.read<EditProfileCubit>().clearMessages();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          surfaceTintColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Modifier mon profil',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                const _ProfileImageCard(),
                SizedBox(height: 16.h),
                const _PersonalInfoCard(),
                SizedBox(height: 16.h),
                const _HealthInfoCard(),
                SizedBox(height: 16.h),
                const _LifeHabitsCard(),
                SizedBox(height: 16.h),
                const _MedicalHistoryCard(),
                SizedBox(height: 100.h), // Space for bottom button
              ],
            ),
          ),
        ),
        bottomNavigationBar: const _SaveButton(),
      ),
    );
  }
}

class _ProfileImageCard extends StatelessWidget {
  const _ProfileImageCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            const _ProfileImageWidget(),
            SizedBox(height: 16.h),
            Text(
              'Photo de profil',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Ajoutez une photo pour personnaliser votre profil',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            BlocBuilder<EditProfileCubit, EditProfileState>(
              builder: (context, state) {
                if (state.hasSelectedImage) {
                  return Wrap(
                    spacing: 12.w,
                    children: [
                      ElevatedButton.icon(
                        onPressed: state.isLoading
                            ? null
                            : () => context.read<EditProfileCubit>().uploadProfileImage(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme().colorScheme.secondary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                        icon: state.isLoading
                            ? SizedBox(
                          width: 16.w,
                          height: 16.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Icon(Icons.upload, size: 18),
                        label: Text(
                          state.isLoading ? 'Envoi...' : 'Enregistrer',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: state.isLoading
                            ? null
                            : () => context.read<EditProfileCubit>().removeSelectedImage(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade400),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                        icon: const Icon(Icons.close, size: 18),
                        label: Text('Annuler', style: TextStyle(fontSize: 14.sp)),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileImageWidget extends StatelessWidget {
  const _ProfileImageWidget();

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Choisir une photo',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: theme().colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: theme().colorScheme.primary,
                        size: 24.sp,
                      ),
                    ),
                    title: Text(
                      'Prendre une photo',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(bottomSheetContext);
                      context.read<EditProfileCubit>().pickImageFromCamera();
                    },
                  ),
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: theme().colorScheme.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.photo_library,
                        color: theme().colorScheme.secondary,
                        size: 24.sp,
                      ),
                    ),
                    title: Text(
                      'Galerie',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(bottomSheetContext);
                      context.read<EditProfileCubit>().pickImageFromGallery();
                    },
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme().colorScheme.primary,
                  width: 3.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: state.hasSelectedImage
                    ? Image.file(
                  File(state.selectedImagePath!),
                  fit: BoxFit.cover,
                )
                    : state.isNetworkImage
                    ? Image.network(
                  state.currentImageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'lib/config/assets/images/default_avatar.jpg',
                    fit: BoxFit.cover,
                  ),
                )
                    : Image.asset(state.displayImagePath, fit: BoxFit.cover),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: state.isLoading ? null : () => _showImageSourceDialog(context),
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: theme().colorScheme.secondary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: state.isLoading
                      ? Padding(
                    padding: EdgeInsets.all(8.w),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PersonalInfoCard extends StatefulWidget {
  const _PersonalInfoCard();

  @override
  State<_PersonalInfoCard> createState() => _PersonalInfoCardState();
}

class _PersonalInfoCardState extends State<_PersonalInfoCard> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<EditProfileCubit>();
    _firstNameController = TextEditingController(text: cubit.state.firstName);
    _lastNameController = TextEditingController(text: cubit.state.lastName);
    _phoneController = TextEditingController(text: cubit.state.phoneNumber);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: 'Informations personnelles',
      icon: Icons.person_outline,
      children: [
        const _ReadOnlyField(
          label: 'Nom d\'utilisateur',
          stateField: 'username',
          icon: Icons.account_circle_outlined,
        ),
        SizedBox(height: 16.h),
        const _ReadOnlyField(
          label: 'Email',
          stateField: 'email',
          icon: Icons.email_outlined,
        ),
        SizedBox(height: 16.h),
        _EditableFieldWithController(
          label: 'Prénom',
          controller: _firstNameController,
          icon: Icons.person_outline,
          onChanged: (val) => context.read<EditProfileCubit>().updateFirstName(val),
        ),
        SizedBox(height: 16.h),
        _EditableFieldWithController(
          label: 'Nom',
          controller: _lastNameController,
          icon: Icons.person_outline,
          onChanged: (val) => context.read<EditProfileCubit>().updateLastName(val),
        ),
        SizedBox(height: 16.h),
        _EditableFieldWithController(
          label: 'Téléphone',
          controller: _phoneController,
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          onChanged: (val) => context.read<EditProfileCubit>().updatePhoneNumber(val),
        ),
      ],
    );
  }
}

class _HealthInfoCard extends StatefulWidget {
  const _HealthInfoCard();

  @override
  State<_HealthInfoCard> createState() => _HealthInfoCardState();
}

class _HealthInfoCardState extends State<_HealthInfoCard> {
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<EditProfileCubit>();
    _weightController = TextEditingController(text: cubit.state.weight?.toString() ?? '');
    _heightController = TextEditingController(text: cubit.state.height?.toString() ?? '');
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: 'Informations de santé',
      icon: Icons.health_and_safety_outlined,
      children: [
        _EditableFieldWithController(
          label: 'Poids (kg)',
          controller: _weightController,
          icon: Icons.monitor_weight_outlined,
          keyboardType: TextInputType.number,
          onChanged: (val) {
            final parsed = double.tryParse(val);
            context.read<EditProfileCubit>().updateWeight(parsed);
          },
        ),
        SizedBox(height: 16.h),
        _EditableFieldWithController(
          label: 'Taille (cm)',
          controller: _heightController,
          icon: Icons.straighten,
          keyboardType: TextInputType.number,
          onChanged: (val) {
            final parsed = double.tryParse(val);
            context.read<EditProfileCubit>().updateHeight(parsed);
          },
        ),
        SizedBox(height: 16.h),
        const _BloodGroupDropdown(),
        SizedBox(height: 16.h),
        const _GenderDropdown(),
        SizedBox(height: 16.h),
        const _DateField(),
      ],
    );
  }
}

class _LifeHabitsCard extends StatelessWidget {
  const _LifeHabitsCard();

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: 'Habitudes de vie',
      icon: Icons.favorite_outline,
      children: [
        const _SwitchField(label: 'Fumeur', stateField: 'smokingStatus'),
        SizedBox(height: 8.h),
        const _SwitchField(label: 'Consommation d\'alcool', stateField: 'alcoholConsumption'),
        SizedBox(height: 8.h),
        const _SwitchField(label: 'Exercice régulier', stateField: 'exerciseRegularly'),
      ],
    );
  }
}

class _MedicalHistoryCard extends StatelessWidget {
  const _MedicalHistoryCard();

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: 'Antécédents médicaux',
      icon: Icons.medical_information_outlined,
      children: [
        const _SwitchField(
          label: 'Antécédents familiaux de maladies cardiaques',
          stateField: 'familyHistoryHeartDisease',
        ),
        SizedBox(height: 8.h),
        const _SwitchField(label: 'Hypertension', stateField: 'hypertensionHistory'),
        SizedBox(height: 8.h),
        const _SwitchField(label: 'Maladie cardiaque', stateField: 'heartDisease'),
        SizedBox(height: 8.h),
        const _SwitchField(label: 'Diabète', stateField: 'diabetes'),
        SizedBox(height: 8.h),
        const _SwitchField(label: 'Cholestérol', stateField: 'cholesterol'),
        SizedBox(height: 8.h),
        const _SwitchField(label: 'Allergies', stateField: 'allergies'),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.children,
    required this.icon,
  });

  final String title;
  final List<Widget> children;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: theme().colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    icon,
                    color: theme().colorScheme.primary,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({
    required this.label,
    required this.stateField,
    this.icon,
  });

  final String label;
  final String stateField;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        String value = '';
        if (stateField == 'username') value = state.username;
        if (stateField == 'email') value = state.email;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: Colors.grey.shade600,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      value.isNotEmpty ? value : '-',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.lock_outline,
                color: Colors.grey.shade400,
                size: 18.sp,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EditableFieldWithController extends StatelessWidget {
  const _EditableFieldWithController({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.keyboardType,
    this.icon,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, size: 20.sp) : null,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: theme().colorScheme.primary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
      ),
      style: TextStyle(fontSize: 16.sp),
    );
  }
}

class _BloodGroupDropdown extends StatelessWidget {
  const _BloodGroupDropdown();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        return DropdownButtonFormField<String>(
          value: state.bloodGroup,
          items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
              .map((group) => DropdownMenuItem(value: group, child: Text(group)))
              .toList(),
          onChanged: (val) => context.read<EditProfileCubit>().updateBloodGroup(val),
          decoration: InputDecoration(
            labelText: 'Groupe sanguin',
            prefixIcon: Icon(Icons.bloodtype_outlined, size: 20.sp),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: theme().colorScheme.primary, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
        );
      },
    );
  }
}

class _GenderDropdown extends StatelessWidget {
  const _GenderDropdown();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        return DropdownButtonFormField<String>(
          value: state.gender,
          items: ['MALE', 'FEMALE', 'OTHER']
              .map(
                (gender) => DropdownMenuItem(
              value: gender,
              child: Text(
                gender == 'MALE'
                    ? 'Homme'
                    : gender == 'FEMALE'
                    ? 'Femme'
                    : 'Autre',
              ),
            ),
          )
              .toList(),
          onChanged: (val) => context.read<EditProfileCubit>().updateGender(val),
          decoration: InputDecoration(
            labelText: 'Genre',
            prefixIcon: Icon(Icons.wc_outlined, size: 20.sp),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: theme().colorScheme.primary, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
        );
      },
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        return TextField(
          controller: TextEditingController(text: state.birthDate ?? ''),
          readOnly: true,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.tryParse(state.birthDate ?? '') ?? DateTime(2000),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              context.read<EditProfileCubit>().updateBirthDate(
                '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
              );
            }
          },
          decoration: InputDecoration(
            labelText: 'Date de naissance',
            prefixIcon: Icon(Icons.calendar_today_outlined, size: 20.sp),
            suffixIcon: const Icon(Icons.arrow_drop_down),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: theme().colorScheme.primary, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
          style: TextStyle(fontSize: 16.sp),
        );
      },
    );
  }
}

class _SwitchField extends StatelessWidget {
  const _SwitchField({required this.label, required this.stateField});
  final String label;
  final String stateField;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        bool value = false;
        if (stateField == 'smokingStatus') value = state.smokingStatus ?? false;
        if (stateField == 'alcoholConsumption') value = state.alcoholConsumption ?? false;
        if (stateField == 'exerciseRegularly') value = state.exerciseRegularly ?? false;
        if (stateField == 'familyHistoryHeartDisease') value = state.familyHistoryHeartDisease ?? false;
        if (stateField == 'hypertensionHistory') value = state.hypertensionHistory ?? false;
        if (stateField == 'heartDisease') value = state.heartDisease ?? false;
        if (stateField == 'diabetes') value = state.diabetes ?? false;
        if (stateField == 'cholesterol') value = state.cholesterol ?? false;
        if (stateField == 'allergies') value = state.allergies ?? false;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Switch(
                value: value,
                onChanged: (val) {
                  if (stateField == 'smokingStatus') {
                    context.read<EditProfileCubit>().updateSmokingStatus(val);
                  }
                  if (stateField == 'alcoholConsumption') {
                    context.read<EditProfileCubit>().updateAlcoholConsumption(val);
                  }
                  if (stateField == 'exerciseRegularly') {
                    context.read<EditProfileCubit>().updateExerciseRegularly(val);
                  }
                  if (stateField == 'familyHistoryHeartDisease') {
                    context.read<EditProfileCubit>().updateFamilyHistoryHeartDisease(val);
                  }
                  if (stateField == 'hypertensionHistory') {
                    context.read<EditProfileCubit>().updateHypertensionHistory(val);
                  }
                  if (stateField == 'heartDisease') {
                    context.read<EditProfileCubit>().updateHeartDisease(val);
                  }
                  if (stateField == 'diabetes') {
                    context.read<EditProfileCubit>().updateDiabetes(val);
                  }
                  if (stateField == 'cholesterol') {
                    context.read<EditProfileCubit>().updateCholesterol(val);
                  }
                  if (stateField == 'allergies') {
                    context.read<EditProfileCubit>().updateAllergies(val);
                  }
                },
                activeColor: theme().colorScheme.primary,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: ElevatedButton(
              onPressed: state.isLoading ? null : () => context.read<EditProfileCubit>().saveProfile(),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme().colorScheme.primary,
                disabledBackgroundColor: theme().colorScheme.primary.withOpacity(0.6),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: state.isLoading
                  ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Text(
                'Enregistrer les modifications',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}