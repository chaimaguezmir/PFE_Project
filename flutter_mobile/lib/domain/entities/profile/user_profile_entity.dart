// lib/domain/entities/profile/user_profile_entity.dart

class UserProfileEntity {
  const UserProfileEntity({
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
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

  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
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
}

// lib/domain/entities/profile/update_profile_entity.dart

class UpdateProfileEntity {
  const UpdateProfileEntity({
    this.firstName,
    this.lastName,
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
  });

  final String? firstName;
  final String? lastName;
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
}