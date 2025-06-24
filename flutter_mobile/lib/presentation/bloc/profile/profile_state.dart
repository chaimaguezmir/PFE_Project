part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  final FormzSubmissionStatus status;
  final String? errorMessage;
  final String? successMessage;

  ProfileState copyWith({
    FormzSubmissionStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  bool get hasError => errorMessage != null;

  bool get hasSuccess => successMessage != null;
  @override
  List<Object?> get props => [status, errorMessage, successMessage];
}
