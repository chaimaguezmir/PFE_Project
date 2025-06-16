import 'dart:ffi';


class GroupEntity {
  GroupEntity({
    required this.groupId,
    required this.name,
    required this.role,
  });

  final String groupId;
  final String name;
  final String role;
}