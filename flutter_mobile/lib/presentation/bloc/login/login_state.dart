part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.rememberMe = false,
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  final String email;
  final String password;
  final bool isPasswordVisible;
  final bool rememberMe;
  final FormzSubmissionStatus status;
  final String? errorMessage;
  final String? successMessage;

  // Computed properties
  bool get isLoading => status == FormzSubmissionStatus.inProgress;
  bool get isSuccess => status == FormzSubmissionStatus.success;
  bool get isFailure => status == FormzSubmissionStatus.failure;
  bool get hasError => errorMessage != null;
  bool get hasSuccess => successMessage != null;

  LoginState copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? rememberMe,
    FormzSubmissionStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      status: status ?? this.status,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    isPasswordVisible,
    rememberMe,
    status,
    errorMessage,
    successMessage,
  ];
}