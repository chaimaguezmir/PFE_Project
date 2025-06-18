import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/data/data_sources/group_remote_datasource.dart';
import 'package:flutter_mobile/domain/entities/group/add_member_entity.dart';
import 'package:flutter_mobile/domain/entities/group/group_entity.dart';
import 'package:flutter_mobile/domain/entities/group/member_entity.dart';
import 'package:flutter_mobile/domain/entities/group/remove_member_entity.dart';
import 'package:flutter_mobile/domain/entities/group/toggle_role_entity.dart';
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

  @override
  Future<DataState<AddMemberEntity>> addMember(
    String token,
    String groupId,
    String email,
  ) async {
    try {
      final result = await _remoteDataSource.addMember(token, groupId, email);
      return DataSuccess(result);
    } on DioException catch (e) {
      print('Errrrrrrrrrrrrrrrrrrr: $e');
      if (e.response?.statusCode == 400) {
        return DataError('Invalid data');
      } else if (e.response?.statusCode == 401) {
        return DataError('Unauthorized');
      } else if (e.response?.statusCode == 404) {
        return DataError('Not Found');
      } else if (e.response?.statusCode == 409) {
        return DataError('Member already exists}');
      }
      return DataError('Error: ${e.message}');
    } catch (e) {
      return DataError('Unexpected error: $e');
    }
  }

  @override
  Future<DataState<ToggleRoleEntity>> toggleRole(
    String token,
    String groupId,
    String targetUserId,
  ) async {
    try {
      final result = await _remoteDataSource.toggleRole(
        token,
        groupId,
        targetUserId,
      );
      return DataSuccess(result);
    } catch (e) {
      return DataError('Failed to toggle role: $e');
    }
  }
  @override
  Future<DataState<RemoveMemberEntity>> removeMember(
      String token,
      String groupId,
      String memberId,

      ) async {
    try {
      final result = await _remoteDataSource.removeMember(token, groupId, memberId);
      return DataSuccess(result);
    } catch (e) {
      return DataError('Failed to remove member: $e');
    }
  }
}
