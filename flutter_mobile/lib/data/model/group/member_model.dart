import 'package:flutter_mobile/domain/entities/group/member_entity.dart';

class MemberModel extends MemberEntity {
  MemberModel({
    required super.userId,
    required super.username,
    required super.role,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      userId: json['userId'],
      username: json['username'],
      role: json['role'],
    );
  }
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'username': username,
    'role': role,
  };
}