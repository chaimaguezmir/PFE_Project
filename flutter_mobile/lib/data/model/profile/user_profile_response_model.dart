// lib/data/model/profile/user_profile_response_model.dart

import 'package:flutter_mobile/domain/entities/profile/user_profile_entity.dart';

class UserProfileResponseModel extends UserProfileEntity {
  const UserProfileResponseModel({
    required super.username,
    required super.email,
    super.firstName,
    super.lastName,
    super.phoneNumber,
    super.weight,
    super.height,
    super.bloodGroup,
    super.gender,
    super.birthDate,
    super.smokingStatus,
    super.alcoholConsumption,
    super.exerciseRegularly,
    super.familyHistoryHeartDisease,
    super.hypertensionHistory,
    super.heartDisease,
    super.diabetes,
    super.cholesterol,
    super.allergies,
    super.profileImageUrl,
  });

  factory UserProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return UserProfileResponseModel(
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      weight: json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      height: json['height'] != null ? (json['height'] as num).toDouble() : null,
      bloodGroup: json['bloodGroup'] as String?,
      gender: json['gender'] as String?,
      birthDate: json['birthDate'] as String?,
      smokingStatus: json['smokingStatus'] as bool?,
      alcoholConsumption: json['alcoholConsumption'] as bool?,
      exerciseRegularly: json['exerciseRegularly'] as bool?,
      familyHistoryHeartDisease: json['familyHistoryHeartDisease'] as bool?,
      hypertensionHistory: json['hypertensionHistory'] as bool?,
      heartDisease: json['heartDisease'] as bool?,
      diabetes: json['diabetes'] as bool?,
      cholesterol: json['cholesterol'] as bool?,
      allergies: json['allergies'] as bool?,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }
}

