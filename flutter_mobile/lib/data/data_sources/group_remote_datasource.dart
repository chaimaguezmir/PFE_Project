import 'package:flutter_mobile/data/model/group/add_member_model.dart';
import 'package:flutter_mobile/data/model/group/member_model.dart';
import 'package:flutter_mobile/data/model/group/remove_member_model.dart';
import 'package:flutter_mobile/data/model/group/toggle_role_model.dart';
import 'package:flutter_mobile/domain/entities/group/group_entity.dart';

abstract class GroupRemoteDataSource {
  Future<List<GroupEntity>> getUserGroups(String userId);
  Future<List<MemberModel>> getGroupMembers(String token, String groupId);
  Future<AddMemberModel> addMember(String token, String groupId, String email);
  Future<ToggleRoleModel> toggleRole(
    String token,
    String groupId,
    String targetUserId,
  );
  Future<RemoveMemberModel> removeMember(
      String token,
      String groupId,
      String memberId,

      );
}

