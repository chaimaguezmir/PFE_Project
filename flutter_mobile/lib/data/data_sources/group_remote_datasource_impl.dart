import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/data/data_sources/group_remote_datasource.dart';
import 'package:flutter_mobile/data/model/group/add_member_model.dart';
import 'package:flutter_mobile/data/model/group/group_model.dart';
import 'package:flutter_mobile/data/model/group/member_model.dart';
import 'package:flutter_mobile/data/model/group/remove_member_model.dart';
import 'package:flutter_mobile/data/model/group/toggle_role_model.dart';

class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  GroupRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<GroupModel>> getUserGroups() async {
    final response = await _dio.get('${ApiEndpoints.baseurl}/groups');

    final data = response.data as List;
    return data.map((json) => GroupModel.fromJson(json)).toList();
  }

  @override
  Future<List<MemberModel>> getGroupMembers(String groupId) async {
    final response = await _dio.get(
      '${ApiEndpoints.baseurl}/groups/$groupId/members',
    );
    final data = response.data as List;
    return data.map((json) => MemberModel.fromJson(json)).toList();
  }

  @override
  Future<AddMemberModel> addMember(String groupId, String email) async {
    final response = await _dio.post(
      '${ApiEndpoints.baseurl}/groups/$groupId/members',
      data: {'email': email},
    );
    return AddMemberModel.fromJson(response.data);
  }

  @override
  Future<ToggleRoleModel> toggleRole(
    String groupId,
    String targetUserId,
  ) async {
    final response = await _dio.put(
      '${ApiEndpoints.baseurl}/groups/members/toggle-role',
      data: {'groupId': groupId, 'targetUserId': targetUserId},
    );
    return ToggleRoleModel.fromJson(response.data);
  }

  @override
  Future<RemoveMemberModel> removeMember(
    String groupId,
    String memberId,
  ) async {
    final response = await _dio.delete(
      '${ApiEndpoints.baseurl}/groups/$groupId/members/$memberId',
    );
    return RemoveMemberModel.fromJson(response.data);
  }
}
