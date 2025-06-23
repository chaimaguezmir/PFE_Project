part of 'group_cubit.dart';

class GroupState extends Equatable {
  const GroupState({
    this.groups = const [],
    this.members = const [],

    this.email = '',
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.isIconSelected = false,
    this.currentGroupUserRole = '',
    this.currentGroupName = '',
    this.currentGroupId = '',
    this.selectedMemberUsername = '',
    this.selectedMemberRole = '',
    this.selectedMemberId='',


  });

  final List<GroupEntity> groups;
  final List<MemberEntity> members;

  final String email;
  final FormzSubmissionStatus status;
  final String? errorMessage;
  final String? successMessage;
  final bool isIconSelected;
  final String currentGroupUserRole;
  final String currentGroupName;
  final String currentGroupId ;
  final String selectedMemberUsername ;
  final String selectedMemberRole;
  final String selectedMemberId;

  GroupState copyWith({
    List<GroupEntity>? groups,
    List<MemberEntity>? members,

    String? email,
    FormzSubmissionStatus? status,
    String? errorMessage,
    String? successMessage,
    bool? isIconSelected,
    String? currentGroupUserRole,
    String? currentGroupName,
    String? currentGroupId,
    String? selectedMemberUsername,
    String? selectedMemberRole,
    String? selectedMemberId,
  }) {
    return GroupState(
      groups: groups ?? this.groups,
      members: members ?? this.members,
      email: email ?? this.email,

      status: status ?? this.status,
      errorMessage: errorMessage,
      successMessage: successMessage,
      isIconSelected: isIconSelected ?? this.isIconSelected,
      currentGroupUserRole: currentGroupUserRole ?? this.currentGroupUserRole,
      currentGroupName: currentGroupName ?? this.currentGroupName,
      currentGroupId: currentGroupId ?? this.currentGroupId,
      selectedMemberUsername: selectedMemberUsername ?? this.selectedMemberUsername,
      selectedMemberRole: selectedMemberRole ?? this.selectedMemberRole,
      selectedMemberId: selectedMemberId ?? this.selectedMemberId,
    );
  }

  bool get hasError => errorMessage != null;

  bool get hasSuccess => successMessage != null;
  @override
  List<Object?> get props => [
    groups,
    members,
    email,
    selectedMemberId,
    status,
    errorMessage,
    successMessage,
    isIconSelected,
    currentGroupUserRole,
    currentGroupName,
    currentGroupId,
    selectedMemberUsername,
    selectedMemberRole,
  ];
}
