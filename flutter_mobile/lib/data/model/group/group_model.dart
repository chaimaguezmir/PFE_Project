// lib/data/models/group_model.dart
import 'package:flutter_mobile/domain/entities/group/group_entity.dart';

class GroupModel extends GroupEntity {
  GroupModel({
    required super.groupId,
    required super.name,
    required super.role,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      groupId: json['groupId'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'groupId': groupId,
    'name': name,
    'role': role,
  };
}
