// lib/presentation/bloc/profile/edit_profile_cubit.dart

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/profile/user_profile_entity.dart';
import 'package:flutter_mobile/domain/repositories/profile_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(this._profileRepository, this._prefs)
    : super(const EditProfileState());

  final ProfileRepository _profileRepository;
  final SharedPreferences _prefs;
  final ImagePicker _picker = ImagePicker();

  void init() {
    loadFromSharedPrefs();
  }

  void loadFromSharedPrefs() {
    try {
      final profileImageUrl = _prefs.getString('profileImageUrl');
      final username = _prefs.getString('username') ?? '';
      final email = _prefs.getString('email') ?? '';
      final firstName = _prefs.getString('firstName');
      final lastName = _prefs.getString('lastName');
      final phoneNumber = _prefs.getString('phoneNumber');
      final weight = _prefs.getDouble('weight');
      final height = _prefs.getDouble('height');
      final bloodGroup = _prefs.getString('bloodGroup');
      final gender = _prefs.getString('gender');
      final birthDate = _prefs.getString('birthDate');
      final smokingStatus = _prefs.getBool('smokingStatus');
      final alcoholConsumption = _prefs.getBool('alcoholConsumption');
      final exerciseRegularly = _prefs.getBool('exerciseRegularly');
      final familyHistoryHeartDisease = _prefs.getBool(
        'familyHistoryHeartDisease',
      );
      final hypertensionHistory = _prefs.getBool('hypertensionHistory');
      final heartDisease = _prefs.getBool('heartDisease');
      final diabetes = _prefs.getBool('diabetes');
      final cholesterol = _prefs.getBool('cholesterol');
      final allergies = _prefs.getBool('allergies');

      print('🔄 Init EditProfile from SharedPrefs');

      emit(
        state.copyWith(
          currentImageUrl: profileImageUrl,
          username: username,
          email: email,
          firstName: firstName ?? '',
          lastName: lastName ?? '',
          phoneNumber: phoneNumber ?? '',
          weight: weight,
          height: height,
          bloodGroup: bloodGroup,
          gender: gender,
          birthDate: birthDate,
          smokingStatus: smokingStatus,
          alcoholConsumption: alcoholConsumption,
          exerciseRegularly: exerciseRegularly,
          familyHistoryHeartDisease: familyHistoryHeartDisease,
          hypertensionHistory: hypertensionHistory,
          heartDisease: heartDisease,
          diabetes: diabetes,
          cholesterol: cholesterol,
          allergies: allergies,
        ),
      );
    } catch (e) {
      print('❌ Error loading from SharedPrefs: $e');
    }
  }

  // Field update methods
  void updateFirstName(String value) => emit(state.copyWith(firstName: value));
  void updateLastName(String value) => emit(state.copyWith(lastName: value));
  void updatePhoneNumber(String value) =>
      emit(state.copyWith(phoneNumber: value));
  void updateWeight(double? value) => emit(state.copyWith(weight: value));
  void updateHeight(double? value) => emit(state.copyWith(height: value));
  void updateBloodGroup(String? value) =>
      emit(state.copyWith(bloodGroup: value));
  void updateGender(String? value) => emit(state.copyWith(gender: value));
  void updateBirthDate(String? value) => emit(state.copyWith(birthDate: value));
  void updateSmokingStatus(bool value) =>
      emit(state.copyWith(smokingStatus: value));
  void updateAlcoholConsumption(bool value) =>
      emit(state.copyWith(alcoholConsumption: value));
  void updateExerciseRegularly(bool value) =>
      emit(state.copyWith(exerciseRegularly: value));
  void updateFamilyHistoryHeartDisease(bool value) =>
      emit(state.copyWith(familyHistoryHeartDisease: value));
  void updateHypertensionHistory(bool value) =>
      emit(state.copyWith(hypertensionHistory: value));
  void updateHeartDisease(bool value) =>
      emit(state.copyWith(heartDisease: value));
  void updateDiabetes(bool value) => emit(state.copyWith(diabetes: value));
  void updateCholesterol(bool value) =>
      emit(state.copyWith(cholesterol: value));
  void updateAllergies(bool value) => emit(state.copyWith(allergies: value));

  Future<void> pickImageFromCamera() async {
    try {
      emit(
        state.copyWith(
          status: EditProfileStatus.loading,
          clearErrorMessage: true,
        ),
      );

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        emit(
          state.copyWith(
            selectedImagePath: image.path,
            status: EditProfileStatus.imageSelected,
          ),
        );
      } else {
        emit(state.copyWith(status: EditProfileStatus.initial));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: EditProfileStatus.failure,
          errorMessage: 'Erreur lors de la prise de photo',
        ),
      );
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      emit(
        state.copyWith(
          status: EditProfileStatus.loading,
          clearErrorMessage: true,
        ),
      );

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        emit(
          state.copyWith(
            selectedImagePath: image.path,
            status: EditProfileStatus.imageSelected,
          ),
        );
      } else {
        emit(state.copyWith(status: EditProfileStatus.initial));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: EditProfileStatus.failure,
          errorMessage: 'Erreur lors de la sélection de l\'image',
        ),
      );
    }
  }

  Future<void> uploadProfileImage() async {
    if (state.selectedImagePath == null) {
      emit(
        state.copyWith(
          status: EditProfileStatus.failure,
          errorMessage: 'Aucune image sélectionnée',
        ),
      );
      return;
    }

    try {
      emit(
        state.copyWith(
          status: EditProfileStatus.uploading,
          clearErrorMessage: true,
        ),
      );

      final result = await _profileRepository.uploadProfileImage(
        state.selectedImagePath!,
      );

      if (result is DataSuccess && result.data != null) {
        final imageUrl = result.data!.imageUrl;
        await _prefs.setString('profileImageUrl', imageUrl);

        emit(
          state.copyWith(
            status: EditProfileStatus.success,
            currentImageUrl: imageUrl,
            clearSelectedImagePath: true,
            successMessage: 'Image mise à jour avec succès',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: EditProfileStatus.failure,
            errorMessage: result.error ?? 'Échec du téléchargement',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: EditProfileStatus.failure,
          errorMessage: 'Une erreur s\'est produite',
        ),
      );
    }
  }

  Future<void> saveProfile() async {
    try {
      emit(
        state.copyWith(
          status: EditProfileStatus.updating,
          clearErrorMessage: true,
        ),
      );

      final updateEntity = UpdateProfileEntity(
        firstName: state.firstName.isNotEmpty ? state.firstName : null,
        lastName: state.lastName.isNotEmpty ? state.lastName : null,
        phoneNumber: state.phoneNumber.isNotEmpty ? state.phoneNumber : null,
        weight: state.weight,
        height: state.height,
        bloodGroup: state.bloodGroup,
        gender: state.gender,
        birthDate: state.birthDate,
        smokingStatus: state.smokingStatus,
        alcoholConsumption: state.alcoholConsumption,
        exerciseRegularly: state.exerciseRegularly,
        familyHistoryHeartDisease: state.familyHistoryHeartDisease,
        hypertensionHistory: state.hypertensionHistory,
        heartDisease: state.heartDisease,
        diabetes: state.diabetes,
        cholesterol: state.cholesterol,
        allergies: state.allergies,
      );

      final result = await _profileRepository.updateUserProfile(updateEntity);

      if (result is DataSuccess && result.data != null) {
        final profile = result.data!;

        // Save to SharedPreferences
        await _saveToSharedPrefs(profile);

        emit(
          state.copyWith(
            status: EditProfileStatus.success,
            successMessage: 'Profil mis à jour avec succès',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: EditProfileStatus.failure,
            errorMessage: result.error ?? 'Échec de la mise à jour',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: EditProfileStatus.failure,
          errorMessage: 'Une erreur s\'est produite',
        ),
      );
    }
  }

  Future<void> _saveToSharedPrefs(dynamic profile) async {
    if (profile.firstName != null)
      await _prefs.setString('firstName', profile.firstName!);
    if (profile.lastName != null)
      await _prefs.setString('lastName', profile.lastName!);
    if (profile.phoneNumber != null)
      await _prefs.setString('phoneNumber', profile.phoneNumber!);
    if (profile.weight != null)
      await _prefs.setDouble('weight', profile.weight!);
    if (profile.height != null)
      await _prefs.setDouble('height', profile.height!);
    if (profile.bloodGroup != null)
      await _prefs.setString('bloodGroup', profile.bloodGroup!);
    if (profile.gender != null)
      await _prefs.setString('gender', profile.gender!);
    if (profile.birthDate != null)
      await _prefs.setString('birthDate', profile.birthDate!);
    if (profile.smokingStatus != null)
      await _prefs.setBool('smokingStatus', profile.smokingStatus!);
    if (profile.alcoholConsumption != null)
      await _prefs.setBool('alcoholConsumption', profile.alcoholConsumption!);
    if (profile.exerciseRegularly != null)
      await _prefs.setBool('exerciseRegularly', profile.exerciseRegularly!);
    if (profile.familyHistoryHeartDisease != null)
      await _prefs.setBool(
        'familyHistoryHeartDisease',
        profile.familyHistoryHeartDisease!,
      );
    if (profile.hypertensionHistory != null)
      await _prefs.setBool('hypertensionHistory', profile.hypertensionHistory!);
    if (profile.heartDisease != null)
      await _prefs.setBool('heartDisease', profile.heartDisease!);
    if (profile.diabetes != null)
      await _prefs.setBool('diabetes', profile.diabetes!);
    if (profile.cholesterol != null)
      await _prefs.setBool('cholesterol', profile.cholesterol!);
    if (profile.allergies != null)
      await _prefs.setBool('allergies', profile.allergies!);
  }

  void removeSelectedImage() {
    emit(
      state.copyWith(
        clearSelectedImagePath: true,
        status: EditProfileStatus.initial,
      ),
    );
  }

  void clearMessages() {
    emit(state.copyWith(clearErrorMessage: true, clearSuccessMessage: true));
  }
}
