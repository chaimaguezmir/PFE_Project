part of 'auth_cubit.dart';

class AuthState extends Equatable {
  const AuthState({this.currentPage = 0});

  final int currentPage;

  AuthState copyWith({int? currentPage}) {
    return AuthState(currentPage: currentPage ?? this.currentPage);
  }

  @override
  List<Object?> get props => [currentPage];
}
