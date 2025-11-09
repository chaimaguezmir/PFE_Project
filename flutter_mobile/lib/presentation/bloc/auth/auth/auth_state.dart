part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  noNetwork,
  backOnLine,
}

sealed class AuthState extends Equatable {
  const AuthState({
    required this.status,
    this.profileImageUrl,
  });

  final AuthStatus status;
  final String? profileImageUrl;

  @override
  List<Object?> get props => [status, profileImageUrl];
}

final class AuthInitial extends AuthState {
  const AuthInitial({super.profileImageUrl}) : super(status: AuthStatus.initial);
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated() : super(status: AuthStatus.unauthenticated);
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({super.profileImageUrl}) : super(status: AuthStatus.authenticated);
}

final class AuthNoNetwork extends AuthState {
  const AuthNoNetwork({super.profileImageUrl}) : super(status: AuthStatus.noNetwork);
}

final class AuthBackOnLine extends AuthState {
  const AuthBackOnLine({super.profileImageUrl}) : super(status: AuthStatus.backOnLine);
}
