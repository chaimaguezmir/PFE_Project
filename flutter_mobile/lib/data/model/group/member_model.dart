// flutter_mobile/lib/data/model/group/member_model.dart
import 'package:flutter_mobile/domain/entities/group/member_entity.dart';

class MemberModel extends MemberEntity {
  MemberModel({
    required super.userId,
    required super.username,
    required super.role,
    super.profileImageUrl,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      userId: json['userId'],
      username: json['username'],
      role: json['role'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'username': username,
    'role': role,
    'profileImageUrl': profileImageUrl,
  };
}