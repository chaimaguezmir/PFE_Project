part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class LoginEvent extends AuthEvent {}

final class LogoutEvent extends AuthEvent {}



class ConnectivityChanged extends AuthEvent {
  const ConnectivityChanged({required this.result});

  final List<ConnectivityResult> result;

  @override
  List<Object> get props => [result];

}

