
import 'package:flutter_mobile/domain/entities/profile/user_profile_entity.dart';

class UpdateProfileRequestModel {
  const UpdateProfileRequestModel({
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

  factory UpdateProfileRequestModel.fromEntity(UpdateProfileEntity entity) {
    return UpdateProfileRequestModel(
      firstName: entity.firstName,
      lastName: entity.lastName,
      phoneNumber: entity.phoneNumber,
      weight: entity.weight,
      height: entity.height,
      bloodGroup: entity.bloodGroup,
      gender: entity.gender,
      birthDate: entity.birthDate,
      smokingStatus: entity.smokingStatus,
      alcoholConsumption: entity.alcoholConsumption,
      exerciseRegularly: entity.exerciseRegularly,
      familyHistoryHeartDisease: entity.familyHistoryHeartDisease,
      hypertensionHistory: entity.hypertensionHistory,
      heartDisease: entity.heartDisease,
      diabetes: entity.diabetes,
      cholesterol: entity.cholesterol,
      allergies: entity.allergies,
    );
  }

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (firstName != null) data['firstName'] = firstName;
    if (lastName != null) data['lastName'] = lastName;
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (weight != null) data['weight'] = weight;
    if (height != null) data['height'] = height;
    if (bloodGroup != null) data['bloodGroup'] = bloodGroup;
    if (gender != null) data['gender'] = gender;
    if (birthDate != null) data['birthDate'] = birthDate;
    if (smokingStatus != null) data['smokingStatus'] = smokingStatus;
    if (alcoholConsumption != null) data['alcoholConsumption'] = alcoholConsumption;
    if (exerciseRegularly != null) data['exerciseRegularly'] = exerciseRegularly;
    if (familyHistoryHeartDisease != null) data['familyHistoryHeartDisease'] = familyHistoryHeartDisease;
    if (hypertensionHistory != null) data['hypertensionHistory'] = hypertensionHistory;
    if (heartDisease != null) data['heartDisease'] = heartDisease;
    if (diabetes != null) data['diabetes'] = diabetes;
    if (cholesterol != null) data['cholesterol'] = cholesterol;
    if (allergies != null) data['allergies'] = allergies;

    return data;
  }
}