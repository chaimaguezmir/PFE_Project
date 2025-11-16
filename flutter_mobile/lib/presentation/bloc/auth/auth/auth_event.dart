part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class LoginEvent extends AuthEvent {}

final class LogoutEvent extends AuthEvent {}

final class ProfileImageUpdated extends AuthEvent {
  const ProfileImageUpdated({required this.imageUrl});

  final String imageUrl;

  @override
  List<Object> get props => [imageUrl];
}

class ConnectivityChanged extends AuthEvent {
  const ConnectivityChanged({required this.result});

  final List<ConnectivityResult> result;

  @override
  List<Object> get props => [result];

}

