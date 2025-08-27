// dart
part of 'welcome_screen_cubit.dart';

enum FormzSubmissionStatus { initial, inProgress, success, failure }

class WelcomeScreenState extends Equatable {
  const WelcomeScreenState({
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.selectedTimeIndex = 0,
  });

  final FormzSubmissionStatus status;
  final String? errorMessage;
  final int selectedTimeIndex;

  WelcomeScreenState copyWith({
    FormzSubmissionStatus? status,
    String? errorMessage,
    int? selectedTimeIndex,
  }) {
    return WelcomeScreenState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      selectedTimeIndex: selectedTimeIndex ?? this.selectedTimeIndex,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, selectedTimeIndex];
}