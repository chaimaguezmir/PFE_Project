// lib/presentation/bloc/profile/edit_profile_cubit.dart

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
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
    try {
      final profileImageUrl = _prefs.getString('profileImageUrl');
      final username = _prefs.getString('username') ?? '';
      final email = _prefs.getString('email') ?? '';
      final firstName = _prefs.getString('firstName');
      final lastName = _prefs.getString('lastName');
      final phoneNumber = _prefs.getString('phoneNumber');

      print('🔄 Init EditProfile - username: $username, email: $email');

      emit(state.copyWith(
        currentImageUrl: profileImageUrl,
        username: username,
        email: email,
        firstName: firstName ?? '',
        lastName: lastName ?? '',
        phoneNumber: phoneNumber ?? '',
      ));
    } catch (e) {
      print('❌ Error in EditProfileCubit.init(): $e');
      emit(state.copyWith(
        status: EditProfileStatus.failure,
        errorMessage: 'Erreur lors du chargement des données',
      ));
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      emit(state.copyWith(
        status: EditProfileStatus.loading,
        clearErrorMessage: true,
      ));

      print('📷 Opening camera...');
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        print('✅ Image captured: ${image.path}');
        emit(state.copyWith(
          selectedImagePath: image.path,
          status: EditProfileStatus.imageSelected,
        ));
      } else {
        print('⚠️ Camera cancelled');
        emit(state.copyWith(status: EditProfileStatus.initial));
      }
    } catch (e) {
      print('❌ Error picking image from camera: $e');
      emit(state.copyWith(
        status: EditProfileStatus.failure,
        errorMessage: 'Erreur lors de la prise de photo: $e',
      ));
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      emit(state.copyWith(
        status: EditProfileStatus.loading,
        clearErrorMessage: true,
      ));

      print('🖼️ Opening gallery...');
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        print('✅ Image selected: ${image.path}');
        emit(state.copyWith(
          selectedImagePath: image.path,
          status: EditProfileStatus.imageSelected,
        ));
        print('🔍 State after selection: selectedImagePath = ${state.selectedImagePath}');
      } else {
        print('⚠️ Gallery cancelled');
        emit(state.copyWith(status: EditProfileStatus.initial));
      }
    } catch (e) {
      print('❌ Error picking image from gallery: $e');
      emit(state.copyWith(
        status: EditProfileStatus.failure,
        errorMessage: 'Erreur lors de la sélection de l\'image: $e',
      ));
    }
  }

  Future<void> uploadProfileImage() async {
    print('🔍 Upload called - selectedImagePath: ${state.selectedImagePath}');

    if (state.selectedImagePath == null) {
      print('⚠️ No image selected');
      emit(state.copyWith(
        status: EditProfileStatus.failure,
        errorMessage: 'Aucune image sélectionnée',
      ));
      return;
    }

    try {
      emit(state.copyWith(
        status: EditProfileStatus.uploading,
        clearErrorMessage: true,
      ));

      print('📤 Uploading image: ${state.selectedImagePath}');

      // Call repository to upload image
      final result = await _profileRepository.uploadProfileImage(
        state.selectedImagePath!,
      );

      print('📥 Upload result type: ${result.runtimeType}');

      if (result is DataSuccess) {
        print('✅ Upload successful');
        print('📦 Result data: ${result.data}');

        if (result.data == null) {
          print('❌ Result data is null');
          emit(state.copyWith(
            status: EditProfileStatus.failure,
            errorMessage: 'Aucune donnée reçue du serveur',
          ));
          return;
        }

        final imageUrl = result.data!.imageUrl;
        print('🖼️ Image URL: $imageUrl');

        if (imageUrl.isEmpty) {
          print('❌ Image URL is empty');
          emit(state.copyWith(
            status: EditProfileStatus.failure,
            errorMessage: 'URL d\'image invalide reçue du serveur',
          ));
          return;
        }

        // Save image URL to SharedPreferences
        await _prefs.setString('profileImageUrl', imageUrl);
        print('💾 Image URL saved to SharedPreferences');

        emit(state.copyWith(
          status: EditProfileStatus.success,
          currentImageUrl: imageUrl,
          clearSelectedImagePath: true, // Clear using flag
          successMessage: 'Image de profil mise à jour avec succès',
        ));
      } else if (result is DataError) {
        print('❌ Upload failed: ${result.error}');
        emit(state.copyWith(
          status: EditProfileStatus.failure,
          errorMessage: result.error ?? 'Échec du téléchargement de l\'image',
        ));
      } else {
        print('❌ Unknown result type: ${result.runtimeType}');
        emit(state.copyWith(
          status: EditProfileStatus.failure,
          errorMessage: 'Réponse inattendue du serveur',
        ));
      }
    } catch (e, stackTrace) {
      print('❌ Exception in uploadProfileImage: $e');
      print('📚 Stack trace: $stackTrace');
      emit(state.copyWith(
        status: EditProfileStatus.failure,
        errorMessage: 'Une erreur inattendue s\'est produite: $e',
      ));
    }
  }

  void removeSelectedImage() {
    print('🗑️ Removing selected image');
    emit(state.copyWith(
      clearSelectedImagePath: true,
      status: EditProfileStatus.initial,
    ));
  }

  void clearMessages() {
    emit(state.copyWith(
      clearErrorMessage: true,
      clearSuccessMessage: true,
    ));
  }
}