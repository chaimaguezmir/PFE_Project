part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  noNetwork,
  backOnLine,
}

sealed class AuthState extends Equatable {
  const AuthState({required this.status});

  final AuthStatus status;

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial() : super(status: AuthStatus.initial);
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated() : super(status: AuthStatus.unauthenticated);
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated() : super(status: AuthStatus.authenticated);
}

final class AuthNoNetwork extends AuthState {
  const AuthNoNetwork() : super(status: AuthStatus.noNetwork);
}

final class AuthBackOnLine extends AuthState {
  const AuthBackOnLine() : super(status: AuthStatus.backOnLine);
}
