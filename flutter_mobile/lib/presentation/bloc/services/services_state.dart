part of 'services_cubit.dart';

class ServicesState extends Equatable {
  const ServicesState({
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.successMessage,
  });
  final FormzSubmissionStatus status;
  final String? errorMessage;
  final String? successMessage;

  ServicesState copyWith({
    FormzSubmissionStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return ServicesState(
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
