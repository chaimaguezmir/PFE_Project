import 'package:flutter_mobile/domain/entities/auth/activate_account_credentials.dart';

class ActivateAccountRequestModel {
  final String email;
  final String code;

  ActivateAccountRequestModel({
    required this.email,
    required this.code,
  });

  factory ActivateAccountRequestModel.fromCredentials(
      ActivateAccountCredentials credentials) {
    return ActivateAccountRequestModel(
      email: credentials.email,
      code: credentials.code,
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'code': code,
  };
}