part of 'services_cubit.dart';

class ServicesState extends Equatable {
  const ServicesState({
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.filteredBoxes = const [],
    this.searchQuery = '',
  });

  final FormzSubmissionStatus status;
  final String? errorMessage;
  final String? successMessage;
  final List<BoxData> filteredBoxes;
  final String searchQuery;

  ServicesState copyWith({
    FormzSubmissionStatus? status,
    String? errorMessage,
    String? successMessage,
    List<BoxData>? filteredBoxes,
    String? searchQuery,
  }) {
    return ServicesState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      filteredBoxes: filteredBoxes ?? this.filteredBoxes,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get hasError => errorMessage != null;
  bool get hasSuccess => successMessage != null;

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    successMessage,
    filteredBoxes,
    searchQuery,
  ];
}
