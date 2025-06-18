import 'package:flutter_mobile/domain/entities/group/remove_member_entity.dart';

class RemoveMemberModel extends RemoveMemberEntity {
  RemoveMemberModel({required super.message});

  factory RemoveMemberModel.fromJson(Map<String, dynamic> json) {
    return RemoveMemberModel(message: json['message'] as String);
  }
}
