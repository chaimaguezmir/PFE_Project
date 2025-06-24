class SignOutRequestEntity {

  SignOutRequestEntity({
    required this.deviceName,
    required this.deviceId,
    required this.refreshToken,
  });
  final String deviceName;
  final String deviceId;
  final String refreshToken;
}