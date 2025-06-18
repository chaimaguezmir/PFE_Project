part of 'group_cubit.dart';

class GroupState extends Equatable {
  const GroupState({
    this.groups = const [],
    this.members = const [],
    this.selectedGroupId = '',
    this.email = '',
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.isIconSelected = false,
  });

  final List<GroupEntity> groups;
  final List<MemberEntity> members;
  final String selectedGroupId;
  final String email;
  final FormzSubmissionStatus status;
  final String? errorMessage;
  final String? successMessage;
  final bool isIconSelected;

  GroupState copyWith({
    List<GroupEntity>? groups,
    List<MemberEntity>? members,
    String? selectedGroupId,
    String? email,
    FormzSubmissionStatus? status,
    String? errorMessage,
    String? successMessage,
    bool? isIconSelected,
  }) {
    return GroupState(
      groups: groups ?? this.groups,
      members: members ?? this.members,
      email: email ?? this.email,
      selectedGroupId: selectedGroupId ?? this.selectedGroupId,
      status: status ?? this.status,
      errorMessage: errorMessage,
      successMessage: successMessage,
      isIconSelected: isIconSelected ?? this.isIconSelected,
    );
  }

  bool get hasError => errorMessage != null;

  bool get hasSuccess => successMessage != null;
  @override
  List<Object?> get props => [
    groups,
    members,
    email,
    selectedGroupId,
    status,
    errorMessage,
    successMessage,
    isIconSelected,
  ];
}
