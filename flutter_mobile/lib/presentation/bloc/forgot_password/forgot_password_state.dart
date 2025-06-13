part of 'forgot_password_cubit.dart';

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.email = '',
    this.errorMessage,
    this.successMessage,
    this.otpCode = '',
    this.status = FormzSubmissionStatus.initial,
    this.isButtonEnabled = false,
    this.otpResendCounter = 0,
    this.password = '',
    this.confirmPassword = '',
    this.isPasswordVisible = false,
  });

  final String email;
  final String otpCode;
  final String? errorMessage;
  final String? successMessage;
  final FormzSubmissionStatus status;
  final bool isButtonEnabled;
  final int otpResendCounter;
  final String password;

  final String confirmPassword;
  final bool isPasswordVisible;

  ForgotPasswordState copyWith({
    String? email,
    String? otpCode,
    String? errorMessage,
    String? successMessage,
    FormzSubmissionStatus? status,
    bool? isButtonEnabled,
    int? otpResendCounter,
    String? password,
    String? confirmPassword,
    bool? isPasswordVisible,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      otpCode: otpCode ?? this.otpCode,
      errorMessage: errorMessage,
      successMessage: successMessage,
      status: status ?? this.status,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      otpResendCounter: otpResendCounter ?? this.otpResendCounter,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }

  // Computed properties for better UX
  bool get isLoading => status == FormzSubmissionStatus.inProgress;

  bool get isSuccess => status == FormzSubmissionStatus.success;

  bool get isFailure => status == FormzSubmissionStatus.failure;

  bool get hasError => errorMessage != null;

  bool get hasSuccess => successMessage != null;

  @override
  List<Object?> get props => [
    email,
    otpCode,
    errorMessage,
    successMessage,
    status,
    isButtonEnabled,
    otpResendCounter,
    password,
    confirmPassword,
    isPasswordVisible,
  ];
}
