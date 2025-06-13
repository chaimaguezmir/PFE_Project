import 'package:flutter_mobile/domain/entities/auth/resend_activation_entity.dart';

class ResendActivationModel {
  ResendActivationModel({required this.message});

  factory ResendActivationModel.fromJson(Map<String, dynamic> json) {
    return ResendActivationModel(message: json['message'] ?? '');
  }

  final String message;

  ResendActivationEntity toEntity() {
    return ResendActivationEntity(message: message);
  }
}
