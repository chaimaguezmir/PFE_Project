// lib/presentation/bloc/profile/edit_profile_state.dart

part of 'edit_profile_cubit.dart';

enum EditProfileStatus {
  initial,
  loading,
  imageSelected,
  uploading,
  updating,
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
    this.weight,
    this.height,
    this.bloodGroup,
    this.gender,
    this.birthDate,
    this.smokingStatus,
    this.alcoholConsumption,
    this.exerciseRegularly,
    this.familyHistoryHeartDisease,
    this.hypertensionHistory,
    this.heartDisease,
    this.diabetes,
    this.cholesterol,
    this.allergies,
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
  final double? weight;
  final double? height;
  final String? bloodGroup;
  final String? gender;
  final String? birthDate;
  final bool? smokingStatus;
  final bool? alcoholConsumption;
  final bool? exerciseRegularly;
  final bool? familyHistoryHeartDisease;
  final bool? hypertensionHistory;
  final bool? heartDisease;
  final bool? diabetes;
  final bool? cholesterol;
  final bool? allergies;
  final String? errorMessage;
  final String? successMessage;

  // Computed properties
  bool get isLoading =>
      status == EditProfileStatus.loading ||
          status == EditProfileStatus.uploading ||
          status == EditProfileStatus.updating;

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
    bool clearSelectedImagePath = false,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    double? weight,
    double? height,
    String? bloodGroup,
    String? gender,
    String? birthDate,
    bool? smokingStatus,
    bool? alcoholConsumption,
    bool? exerciseRegularly,
    bool? familyHistoryHeartDisease,
    bool? hypertensionHistory,
    bool? heartDisease,
    bool? diabetes,
    bool? cholesterol,
    bool? allergies,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? successMessage,
    bool clearSuccessMessage = false,
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
      weight: weight ?? this.weight,
      height: height ?? this.height,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      smokingStatus: smokingStatus ?? this.smokingStatus,
      alcoholConsumption: alcoholConsumption ?? this.alcoholConsumption,
      exerciseRegularly: exerciseRegularly ?? this.exerciseRegularly,
      familyHistoryHeartDisease: familyHistoryHeartDisease ?? this.familyHistoryHeartDisease,
      hypertensionHistory: hypertensionHistory ?? this.hypertensionHistory,
      heartDisease: heartDisease ?? this.heartDisease,
      diabetes: diabetes ?? this.diabetes,
      cholesterol: cholesterol ?? this.cholesterol,
      allergies: allergies ?? this.allergies,
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
    weight,
    height,
    bloodGroup,
    gender,
    birthDate,
    smokingStatus,
    alcoholConsumption,
    exerciseRegularly,
    familyHistoryHeartDisease,
    hypertensionHistory,
    heartDisease,
    diabetes,
    cholesterol,
    allergies,
    errorMessage,
    successMessage,
  ];
}