part of 'group_cubit.dart';

class GroupState extends Equatable {
  const GroupState({
    this.groups = const [],
    this.members = const [],
    this.selectedGroupId = '',
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final List<GroupEntity> groups;
  final List<MemberEntity> members;
  final String selectedGroupId;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  GroupState copyWith({
    List<GroupEntity>? groups,
    List<MemberEntity>? members,
    String? selectedGroupId,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return GroupState(
      groups: groups ?? this.groups,
      members: members ?? this.members,
      selectedGroupId: selectedGroupId ?? this.selectedGroupId,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    groups,
    members,
    selectedGroupId,
    status,
    errorMessage,
  ];
}
