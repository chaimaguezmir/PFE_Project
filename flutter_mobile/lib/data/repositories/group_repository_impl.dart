import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/data/data_sources/group_remote_datasource.dart';
import 'package:flutter_mobile/domain/entities/group/group_entity.dart';
import 'package:flutter_mobile/domain/entities/group/member_entity.dart';
import 'package:flutter_mobile/domain/repositories/group_repository.dart';

class GroupRepositoryImpl implements GroupRepository {
  GroupRepositoryImpl(this._remoteDataSource);
  final GroupRemoteDataSource _remoteDataSource;

  @override
  Future<DataState<List<GroupEntity>>> getUserGroups(String token) async {
    try {
      final result = await _remoteDataSource.getUserGroups(token);
      return DataSuccess(result);
    } catch (e) {
      return DataError('Failed to fetch groups: $e');
    }
  }

  @override
  Future<DataState<List<MemberEntity>>> getGroupMembers(
    String token,
    String groupId,
  ) async {
    try {
      final result = await _remoteDataSource.getGroupMembers(token, groupId);
      return DataSuccess(result);
    } catch (e) {
      return DataError('Failed to fetch group members: $e');
    }
  }
}
