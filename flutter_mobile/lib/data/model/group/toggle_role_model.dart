import 'package:flutter_mobile/domain/entities/group/toggle_role_entity.dart';

class ToggleRoleModel extends ToggleRoleEntity {
  ToggleRoleModel({required super.message});

  factory ToggleRoleModel.fromJson(Map<String, dynamic> json) {
    return ToggleRoleModel(message: json['message'] as String);
  }
}
