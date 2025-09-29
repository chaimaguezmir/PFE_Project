class LoginResultEntity {
  LoginResultEntity({
    required this.token,
    required this.type,
    required this.refreshToken,
    required this.id,
    required this.username,
    required this.email,
    required this.roles,
    this.firstName,
    this.lastName,
    required this.deviceName,
    required this.deviceId,
    this.phoneNumber,
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
    this.profileImageUrl,
  });

  final String token;
  final String type;
  final String refreshToken;
  final String id;
  final String username;
  final String email;
  final List<String> roles;
  final String? firstName;
  final String? lastName;
  final String deviceName;
  final String deviceId;
  final String? phoneNumber;
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
  final String? profileImageUrl;

  // Helper getter for display name
  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    }
    return username;
  }

  // Helper getter for profile image with default
  String get avatarPath {
    return profileImageUrl ?? 'lib/config/assets/images/default_avatar.jpg';
  }
}