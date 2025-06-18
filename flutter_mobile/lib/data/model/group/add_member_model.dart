import 'package:flutter_mobile/domain/entities/group/add_member_entity.dart';

class AddMemberModel extends AddMemberEntity {
  AddMemberModel({required super.message});

  factory AddMemberModel.fromJson(Map<String, dynamic> json) {
    return AddMemberModel(message: json['message'] as String);
  }
}