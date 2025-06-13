import 'package:flutter_mobile/domain/entities/auth/login_credentials.dart';

class LoginRequestModel {
  LoginRequestModel({required this.email, required this.password});

  factory LoginRequestModel.fromCredentials(LoginCredentials credentials) {
    return LoginRequestModel(
      email: credentials.email,
      password: credentials.password,
    );
  }

  final String email;
  final String password;

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}
