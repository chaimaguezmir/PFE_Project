import 'package:flutter_mobile/domain/entities/auth/login_result_entity.dart';

class LoginResultModel {
  LoginResultModel({
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

  factory LoginResultModel.fromEntity(LoginResultEntity entity) {
    return LoginResultModel(
      token: entity.token,
      type: entity.type,
      refreshToken: entity.refreshToken,
      id: entity.id,
      username: entity.username,
      email: entity.email,
      roles: entity.roles,
      firstName: entity.firstName,
      lastName: entity.lastName,
      deviceName: entity.deviceName,
      deviceId: entity.deviceId,
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
      profileImageUrl: entity.profileImageUrl,
    );
  }

  factory LoginResultModel.fromJson(Map<String, dynamic> json) {
    return LoginResultModel(
      token: json['token'] as String,
      type: json['type'] as String,
      refreshToken: json['refreshToken'] as String,
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      roles: List<String>.from(json['roles'] as List),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      deviceName: json['deviceName'] as String,
      deviceId: json['deviceId'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      weight: json['weight'] as double?,
      height: json['height'] as double?,
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

  LoginResultEntity toEntity() => LoginResultEntity(
    token: token,
    type: type,
    refreshToken: refreshToken,
    id: id,
    username: username,
    email: email,
    roles: roles,
    firstName: firstName,
    lastName: lastName,
    deviceName: deviceName,
    deviceId: deviceId,
    phoneNumber: phoneNumber,
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
    profileImageUrl: profileImageUrl,
  );
}