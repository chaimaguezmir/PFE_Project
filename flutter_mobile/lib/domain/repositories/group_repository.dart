import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/group/group_entity.dart';
import 'package:flutter_mobile/domain/entities/group/member_entity.dart';



abstract class GroupRepository {
  Future<DataState<List<GroupEntity>>> getUserGroups(String userId);
  Future<DataState<List<MemberEntity>>> getGroupMembers(String token, String groupId);

}