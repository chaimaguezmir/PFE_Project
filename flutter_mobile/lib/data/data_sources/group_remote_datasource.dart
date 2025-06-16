import 'package:flutter_mobile/data/model/group/member_model.dart';
import 'package:flutter_mobile/domain/entities/group/group_entity.dart';

abstract class GroupRemoteDataSource {
  Future<List<GroupEntity>> getUserGroups(String userId);
  Future<List<MemberModel>> getGroupMembers(String token, String groupId);
}
