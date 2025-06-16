import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/data/data_sources/group_remote_datasource.dart';
import 'package:flutter_mobile/data/model/group/group_model.dart';
import 'package:flutter_mobile/data/model/group/member_model.dart';


class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  GroupRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<GroupModel>> getUserGroups(String token) async {
    final response = await _dio.get(
      '${ApiEndpoints.baseurl}/groups',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    final data = response.data as List;
    return data.map((json) => GroupModel.fromJson(json)).toList();

  }
  @override
  Future<List<MemberModel>> getGroupMembers(String token, String groupId) async {
    final response = await _dio.get(
      '${ApiEndpoints.baseurl}/groups/$groupId/members',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    final data = response.data as List;
    return data.map((json) => MemberModel.fromJson(json)).toList();
  }
}