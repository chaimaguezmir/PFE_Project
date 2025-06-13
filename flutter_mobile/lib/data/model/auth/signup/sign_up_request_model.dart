import '../../../../domain/entities/auth/sign_up_credentials.dart';

class SignUpRequestModel {
  SignUpRequestModel({
    required this.username,
    required this.email,
    required this.password,
  });

  factory SignUpRequestModel.fromCredentials(SignUpCredentials credentials) {
    return SignUpRequestModel(
      username: credentials.username,
      email: credentials.email,
      password: credentials.password,
    );
  }

  final String username;
  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
  };
}
