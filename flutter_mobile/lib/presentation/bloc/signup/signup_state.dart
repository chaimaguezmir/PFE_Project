part of 'signup_cubit.dart';

enum Gender { male, female,none}
class SignUpState extends Equatable {
  const SignUpState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.phoneNumber = '',
    this.birthdate ='',
    this.gender=Gender.none,
    this.confirmPassword = '',
    this.otpCode = 0,
    this.isPasswordVisible = false,
    this.isTermsAccepted = false,
    this.status = FormzSubmissionStatus.initial,
  });
  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  final String birthdate;
  final Gender gender;
  final String confirmPassword;
  final int otpCode;
  final bool isPasswordVisible;
  final bool isTermsAccepted;
  final FormzSubmissionStatus status;

  SignUpState copyWith({
    String? username,
    String? email,
    String? password,
    String? phoneNumber,
    String? birthdate,
    Gender? gender,
    String? confirmPassword,
    int? otpCode,
    bool? isPasswordVisible,
    bool? isTermsAccepted,
    FormzSubmissionStatus? status,
  }) {
    return SignUpState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      birthdate: birthdate ?? this.birthdate,
      gender: gender??this.gender,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      otpCode: otpCode ?? this.otpCode,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
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