class LoginResultEntity {
  LoginResultEntity({
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
  });

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
}
