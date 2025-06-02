part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final int currentPage;

  const AuthState({this.currentPage = 0});

  AuthState copyWith({int? currentPage}) {
    return AuthState(currentPage: currentPage ?? this.currentPage);
  }

  @override
  List<Object?> get props => [currentPage];
}
