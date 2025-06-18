import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/group/add_member_entity.dart';
import 'package:flutter_mobile/domain/entities/group/group_entity.dart';
import 'package:flutter_mobile/domain/entities/group/member_entity.dart';
import 'package:flutter_mobile/domain/entities/group/remove_member_entity.dart';
import 'package:flutter_mobile/domain/entities/group/toggle_role_entity.dart';

abstract class GroupRepository {
  Future<DataState<List<GroupEntity>>> getUserGroups(String userId);
  Future<DataState<List<MemberEntity>>> getGroupMembers(
    String token,
    String groupId,
  );
  Future<DataState<AddMemberEntity>> addMember(
    String token,
    String groupId,
    String email,
  );
  Future<DataState<ToggleRoleEntity>> toggleRole(
    String token,
    String groupId,
    String targetUserId,
  );
  Future<DataState<RemoveMemberEntity>> removeMember(
    String token,
    String groupId,
    String memberId,

  );
}
