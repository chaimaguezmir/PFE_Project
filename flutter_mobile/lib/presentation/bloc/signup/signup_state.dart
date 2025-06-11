part of 'signup_cubit.dart';

enum Gender { male, female, none }

class SignUpState extends Equatable {
  const SignUpState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.phoneNumber = '',
    this.birthdate = '',
    this.gender = Gender.none,
    this.confirmPassword = '',
    this.otpCode = '',
    this.isPasswordVisible = false,
    this.isTermsAccepted = false,
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.otpResendCounter=0,
    this.isButtonEnabled = false,
  });

  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  final String birthdate;
  final Gender gender;
  final String confirmPassword;
  final String otpCode;
  final bool isPasswordVisible;
  final bool isTermsAccepted;
  final FormzSubmissionStatus status;
  final String? errorMessage;
  final String? successMessage;
  final int? otpResendCounter ;
  final bool isButtonEnabled;

  // Computed properties for better UX
  bool get isLoading => status == FormzSubmissionStatus.inProgress;
  bool get isSuccess => status == FormzSubmissionStatus.success;
  bool get isFailure => status == FormzSubmissionStatus.failure;
  bool get hasError => errorMessage != null;
  bool get hasSuccess => successMessage != null;

  SignUpState copyWith({
    String? username,
    String? email,
    String? password,
    String? phoneNumber,
    String? birthdate,
    Gender? gender,
    String? confirmPassword,
    String? otpCode,
    bool? isPasswordVisible,
    bool? isTermsAccepted,
    FormzSubmissionStatus? status,
    String? errorMessage,
    String? successMessage,
    int? otpResendCounter,
    bool? isButtonEnabled,

  }) {
    return SignUpState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      otpCode: otpCode ?? this.otpCode,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
      status: status ?? this.status,
      errorMessage: errorMessage,
      successMessage: successMessage,
      otpResendCounter: otpResendCounter ?? this.otpResendCounter,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
    );
  }

  @override
  List<Object?> get props => [
    username,
    email,
    password,
    phoneNumber,
    birthdate,
    gender,
    confirmPassword,
    otpCode,
    isPasswordVisible,
    isTermsAccepted,
    status,
    errorMessage,
    successMessage,
    otpResendCounter,
    isButtonEnabled,

  ];
}

extension GenderExtension on Gender {
  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      default:
        return 'None';
    }
  }
}