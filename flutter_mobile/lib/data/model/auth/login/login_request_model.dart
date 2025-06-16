import 'package:flutter_mobile/domain/entities/auth/login_credentials.dart';

class LoginRequestModel {
  LoginRequestModel({
    required this.email,
    required this.password,
    required this.deviceId ,
    required this.deviceName ,
  });

  factory LoginRequestModel.fromCredentials(LoginCredentials credentials) {
    return LoginRequestModel(
      email: credentials.email,
      password: credentials.password,
      deviceId: credentials.deviceId,
      deviceName: credentials.deviceName,
    );
  }

  final String email;
  final String password;
  final String deviceId;
  final String deviceName;

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'deviceId': deviceId,
    'deviceName': deviceName,
  };
}