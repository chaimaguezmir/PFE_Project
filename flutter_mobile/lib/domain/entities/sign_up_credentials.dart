import 'package:equatable/equatable.dart';

class SignUpCredentials extends Equatable {
  const SignUpCredentials({
    required this.username,
    required this.email,
    required this.password,
  });

  final String username;
  final String email;

  final String password;

  @override
  List<Object?> get props => [username, email, password];
}
