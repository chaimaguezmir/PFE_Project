// lib/presentation/bloc/profile/edit_profile_state.dart

part of 'edit_profile_cubit.dart';

enum EditProfileStatus {
  initial,
  loading,
  imageSelected,
  uploading,
  success,
  failure,
}

class EditProfileState extends Equatable {
  const EditProfileState({
    this.status = EditProfileStatus.initial,
    this.currentImageUrl,
    this.selectedImagePath,
    this.username = '',
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.errorMessage,
    this.successMessage,
  });

  final EditProfileStatus status;
  final String? currentImageUrl;
  final String? selectedImagePath;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? errorMessage;
  final String? successMessage;

  // Computed properties
  bool get isLoading =>
      status == EditProfileStatus.loading ||
          status == EditProfileStatus.uploading;

  bool get hasSelectedImage => selectedImagePath != null;

  bool get hasCurrentImage =>
      currentImageUrl != null &&
          currentImageUrl!.isNotEmpty &&
          currentImageUrl != 'lib/config/assets/images/default_avatar.jpg';

  String get displayImagePath {
    if (selectedImagePath != null) {
      return selectedImagePath!;
    } else if (hasCurrentImage) {
      return currentImageUrl!;
    }
    return 'lib/config/assets/images/default_avatar.jpg';
  }

  bool get isNetworkImage =>
      hasCurrentImage &&
          (currentImageUrl!.startsWith('http://') ||
              currentImageUrl!.startsWith('https://'));

  EditProfileState copyWith({
    EditProfileStatus? status,
    String? currentImageUrl,
    String? selectedImagePath,
    bool clearSelectedImagePath = false, // NEW: flag to explicitly clear
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? errorMessage,
    bool clearErrorMessage = false, // NEW: flag to explicitly clear
    String? successMessage,
    bool clearSuccessMessage = false, // NEW: flag to explicitly clear
  }) {
    return EditProfileState(
      status: status ?? this.status,
      currentImageUrl: currentImageUrl ?? this.currentImageUrl,
      selectedImagePath: clearSelectedImagePath
          ? null
          : (selectedImagePath ?? this.selectedImagePath),
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccessMessage
          ? null
          : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentImageUrl,
    selectedImagePath,
    username,
    email,
    firstName,
    lastName,
    phoneNumber,
    errorMessage,
    successMessage,
  ];
}