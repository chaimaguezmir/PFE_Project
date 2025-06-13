import 'package:flutter_mobile/domain/entities/auth/forgot_password_result_entity.dart';

class ForgotPasswordResultModel {
  ForgotPasswordResultModel({required this.message});

  factory ForgotPasswordResultModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResultModel(message: json['message'] ?? '');
  }

  final String message;

  ForgotPasswordResultEntity toEntity() =>
      ForgotPasswordResultEntity(message: message);
}
