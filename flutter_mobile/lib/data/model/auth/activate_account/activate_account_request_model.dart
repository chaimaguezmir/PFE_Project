import 'package:flutter_mobile/domain/entities/auth/activate_account_credentials.dart';

class ActivateAccountRequestModel {
  ActivateAccountRequestModel({required this.email, required this.code});

  factory ActivateAccountRequestModel.fromCredentials(
    ActivateAccountCredentials credentials,
  ) {
    return ActivateAccountRequestModel(
      email: credentials.email,
      code: credentials.code,
    );
  }

  final String email;
  final String code;

  Map<String, dynamic> toJson() => {'email': email, 'code': code};
}
