import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/group/add_member_entity.dart';
import 'package:flutter_mobile/domain/entities/group/group_entity.dart';
import 'package:flutter_mobile/domain/entities/group/member_entity.dart';
import 'package:flutter_mobile/domain/entities/group/remove_member_entity.dart';
import 'package:flutter_mobile/domain/entities/group/toggle_role_entity.dart';

abstract class GroupRepository {
  Future<DataState<List<GroupEntity>>> getUserGroups();
  Future<DataState<List<MemberEntity>>> getGroupMembers(String groupId);
  Future<DataState<AddMemberEntity>> addMember(String groupId, String email);
  Future<DataState<ToggleRoleEntity>> toggleRole(
      String groupId,
      String targetUserId,
      );
  Future<DataState<RemoveMemberEntity>> removeMember(
      String groupId,
      String memberId,
      );

  // New method for creating groups
  Future<DataState<GroupEntity>> createGroup(String groupName);
}