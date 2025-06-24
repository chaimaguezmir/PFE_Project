import 'package:flutter_mobile/domain/entities/auth/sign_out_request_entity.dart';

class SignOutRequestModel {

  factory SignOutRequestModel.fromEntity(SignOutRequestEntity entity) {
    return SignOutRequestModel(
      deviceName: entity.deviceName,
      deviceId: entity.deviceId,
      refreshToken: entity.refreshToken,
    );
  }

  SignOutRequestModel({
    required this.deviceName,
    required this.deviceId,
    required this.refreshToken,
  });
  final String deviceName;
  final String deviceId;
  final String refreshToken;

  Map<String, dynamic> toJson() => {
    'deviceName': deviceName,
    'deviceId': deviceId,
    'refreshToken': refreshToken,
  };
}