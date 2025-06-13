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
    required this.firstName,
    required this.lastName,
    required this.deviceName,
    required this.deviceId,
  });

  factory LoginResultModel.fromJson(Map<String, dynamic> json) {
    return LoginResultModel(
      token: json['token'],
      type: json['type'],
      refreshToken: json['refreshToken'],
      id: json['id'],
      username: json['username'],
      email: json['email'],
      roles: List<String>.from(json['roles']),
      firstName: json['firstName'],
      lastName: json['lastName'],
      deviceName: json['deviceName'],
      deviceId: json['deviceId'],
    );
  }

  final String token;
  final String type;
  final String refreshToken;
  final String id;
  final String username;
  final String email;
  final List<String> roles;
  final String firstName;
  final String lastName;
  final String deviceName;
  final String deviceId;

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
  );
}
